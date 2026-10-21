"""Export individual meshes from a .blend file using a background Blender process."""

import argparse
from pathlib import Path
import re
import sys


class ExportError(Exception):
    """An expected file or Blender operation failure reported without a traceback."""


def parse_args(argv=None):
    if argv is None:
        argv = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
    parser = argparse.ArgumentParser(
        prog="blender --background --python scripts/batch_export_models.py --",
        description=__doc__,
    )
    parser.add_argument("blend_file", type=Path, help="Source .blend file")
    parser.add_argument("output_dir", type=Path, nargs="?", help="Default: <blend stem>_exports")
    parser.add_argument("--format", choices=("gltf", "glb"), default="glb")
    parser.add_argument("--selected-only", action="store_true", help="Use the selection saved in the file")
    parser.add_argument(
        "--on-exists", choices=("overwrite", "number", "stop"),
        help="Handle every filename conflict automatically; prompt when omitted",
    )
    return parser.parse_args(argv)


def export_path(output_dir, object_name, file_format, on_exists=None):
    """Apply a collision policy or ask; return None to stop the batch."""
    if on_exists not in (None, "overwrite", "number", "stop"):
        raise ValueError(f"Unknown conflict policy: {on_exists}")
    name = re.sub(r"[^A-Za-z0-9_-]", "_", object_name) or "Object"
    entries = list(output_dir.iterdir())
    existing = {path.stem.casefold() for path in entries}
    filepath = output_dir / f"{name}.{file_format}"
    if name.casefold() not in existing:
        return filepath

    if on_exists is None:
        print(f"An export with the name '{name}' already exists in {output_dir}.")
        print("1. Overwrite existing export")
        print("2. Keep existing export and add a numbered suffix to the new export")
        print("3. Stop exporting")
        choices = {"1": "overwrite", "2": "number", "3": "stop"}
        while on_exists is None:
            try:
                choice = input("Choose [1/2/3]: ").strip()
            except (EOFError, KeyboardInterrupt):
                print("\nNo choice received; stopping export.")
                return None
            on_exists = choices.get(choice)
            if on_exists is None:
                print("Enter 1, 2, or 3.")

    if on_exists == "stop":
        return None
    if on_exists == "overwrite":
        # Reuse the actual spelling when the existing filename differs in case.
        filepath = next(
            (path for path in entries if path.name.casefold() == filepath.name.casefold()),
            filepath,
        )
        if filepath.is_dir():
            raise IsADirectoryError(filepath)
        return filepath

    stem = name
    suffix = 1
    while stem.casefold() in existing:
        stem = f"{name}_{suffix}"
        suffix += 1
    return output_dir / f"{stem}.{file_format}"


def export_models(args):
    import bpy  # pyright: ignore[reportMissingModuleSource]

    try:
        bpy.ops.wm.open_mainfile(filepath=str(args.blend_file))
        if bpy.context.mode != 'OBJECT':
            bpy.ops.object.mode_set(mode='OBJECT')
    except RuntimeError as error:
        raise ExportError(f"Could not prepare the Blender file: {error}") from error

    view_layer = bpy.context.view_layer
    if not isinstance(view_layer, bpy.types.ViewLayer):
        print("Nothing exported: the file has no active view layer.")
        return
    selected = list(bpy.context.selected_objects)
    if args.selected_only and not selected:
        print("Nothing exported: no saved selection. Save a selection or omit --selected-only.")
        return
    active = view_layer.objects.active
    candidates = selected if args.selected_only else list(view_layer.objects)
    objects = sorted(
        (obj for obj in candidates if obj.type == 'MESH' and obj.visible_get()),
        key=lambda obj: obj.name,
    )
    if not objects:
        if args.selected_only:
            print("Nothing exported: the saved selection contains no visible meshes.")
        else:
            print("Nothing exported: no visible meshes in the active view layer.")
        return

    args.output_dir.mkdir(parents=True, exist_ok=True)
    exported = 0
    try:
        for obj in selected:
            obj.select_set(False)
        for obj in objects:
            filepath = export_path(args.output_dir, obj.name, args.format, args.on_exists)
            if filepath is None:
                print("Export stopped; completed files kept.")
                break
            if not any(slot.material for slot in obj.material_slots):
                print(f"Note: {obj.name} has no assigned material.")
            locked = obj.hide_select
            try:
                obj.hide_select = False
                obj.select_set(True)
                view_layer.objects.active = obj
                try:
                    result = bpy.ops.export_scene.gltf(
                        filepath=str(filepath),
                        check_existing=False,
                        export_format='GLTF_SEPARATE' if args.format == "gltf" else 'GLB',
                        use_selection=True,
                        export_materials='EXPORT',
                        export_image_format='AUTO',
                        export_texture_dir="",
                    )
                except RuntimeError as error:
                    raise ExportError(f"Could not export {obj.name}: {error}") from error
                if result != {'FINISHED'} or not filepath.is_file():
                    raise ExportError(f"Export failed: {obj.name}")
                print(f"Written: {filepath}", flush=True)
                exported += 1
            finally:
                obj.select_set(False)
                obj.hide_select = locked
    finally:
        for obj in selected:
            obj.select_set(True)
        view_layer.objects.active = active
    print(f"Exported {exported} mesh object(s) to {args.output_dir}")


def main(argv=None):
    args = parse_args(argv)
    try:
        args.blend_file = args.blend_file.expanduser().resolve()
        if not args.blend_file.is_file() or args.blend_file.suffix.lower() != ".blend":
            print(f"Expected an existing .blend file: {args.blend_file}", file=sys.stderr)
            return 2
        args.output_dir = (
            args.output_dir or args.blend_file.with_name(args.blend_file.stem + "_exports")
        ).expanduser().resolve()
        export_models(args)
    except (OSError, ExportError) as error:
        print(f"Export stopped: {' '.join(str(error).split())}", file=sys.stderr)
        return 1
    except KeyboardInterrupt:
        print("\nExport interrupted; completed files kept.")
        return 130
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
