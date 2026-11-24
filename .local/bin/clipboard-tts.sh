#!/usr/bin/env bash
# Read clipboard text aloud using a local Piper voice.
set -euo pipefail

usage() {
    cat <<'EOF'
Usage: clipboard-tts.sh [MODEL.onnx]

Read the clipboard aloud with Piper. Set PIPER_MODEL to omit the argument.
Run again while speaking to stop synthesis or playback.
By default, uses ~/.local/share/piper/en_US-ryan-medium.onnx
(or $XDG_DATA_HOME/piper/en_US-ryan-medium.onnx).
The matching MODEL.onnx.json configuration must be beside the model.

Requires piper, flock, setsid, wl-paste (Wayland) or xclip/xsel (X11), and one of
pw-play, paplay, aplay, or ffplay.
EOF
}

die() { printf 'clipboard-tts: %s\n' "$*" >&2; exit 1; }

if [[ ${1:-} == --help || ${1:-} == -h ]]; then
    usage
    exit 0
fi

(( $# <= 1 )) || die 'Expected at most one model path. See --help.'

command -v flock >/dev/null 2>&1 || die 'flock is not installed.'
command -v setsid >/dev/null 2>&1 || die 'setsid is not installed.'
umask 077
state_dir=${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}/clipboard-tts-$UID
mkdir -p -- "$state_dir"
[[ -d $state_dir && -O $state_dir && ! -L $state_dir ]] || die 'Unsafe runtime directory.'
chmod 700 -- "$state_dir"

# Serialize toggle requests. The active lock also distinguishes stale PID files.
# Keep lock files in place so all invocations lock the same inodes.
exec 9>"$state_dir/toggle.lock"
flock 9
exec 8>"$state_dir/active.lock"
if ! flock -n 8; then
    if read -r active_pid < "$state_dir/pid" && [[ $active_pid =~ ^[0-9]+$ ]]; then
        kill -TERM "$active_pid" 2>/dev/null || true
    fi
    exit 0
fi

child_pid=
temp_dir=
cleanup() {
    trap '' INT TERM
    if [[ -n $child_pid ]]; then
        # Each command has its own process group, including any descendants.
        kill -TERM -- "-$child_pid" 2>/dev/null || true
        kill -TERM "$child_pid" 2>/dev/null || true
        wait "$child_pid" 2>/dev/null || true
    fi
    rm -f -- "$state_dir/pid"
    [[ -z $temp_dir ]] || rm -rf -- "$temp_dir"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
printf '%s\n' "$$" > "$state_dir/pid"
flock -u 9
exec 9>&-

run_command() {
    # Background + wait lets Bash handle stop signals immediately.
    # Do not let commands inherit the active lock.
    setsid -- "$@" 8>&- &
    child_pid=$!
    local status=0
    wait "$child_pid" || status=$?
    child_pid=
    return "$status"
}

model=${1:-${PIPER_MODEL:-${XDG_DATA_HOME:-$HOME/.local/share}/piper/en_US-ryan-medium.onnx}}

command -v piper >/dev/null 2>&1 || die 'piper is not installed or is not on PATH.'
[[ -r $model ]] || die "Voice model not found: $model. Pass a model path or set PIPER_MODEL."
[[ -r $model.json ]] || die "Voice configuration not found: $model.json"

if [[ -n ${WAYLAND_DISPLAY:-} ]] && command -v wl-paste >/dev/null 2>&1; then
    clipboard=(wl-paste --no-newline --type text)
elif [[ -n ${DISPLAY:-} ]] && command -v xclip >/dev/null 2>&1; then
    clipboard=(xclip -selection clipboard -out)
elif [[ -n ${DISPLAY:-} ]] && command -v xsel >/dev/null 2>&1; then
    clipboard=(xsel --clipboard --output)
else
    die 'No clipboard reader available for this session. Use wl-paste on Wayland or xclip/xsel on X11.'
fi

player=()
for candidate in pw-play paplay aplay ffplay; do
    if command -v "$candidate" >/dev/null 2>&1; then
        player=("$candidate")
        break
    fi
done
(( ${#player[@]} )) || die 'Install an audio player: pw-play, paplay, aplay, or ffplay.'
if [[ ${player[0]} == ffplay ]]; then
    player+=(-nodisp -autoexit -loglevel error)
fi

temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/clipboard-tts.XXXXXXXX")
run_command "${clipboard[@]}" > "$temp_dir/input.txt" || die 'Could not read clipboard text.'
text=$(< "$temp_dir/input.txt")
[[ -n ${text//[[:space:]]/} ]] || die 'The clipboard contains no text.'

# Background commands receive /dev/null on stdin unless explicitly redirected.
# Give Piper the input file directly so toggling does not discard its text.
run_command piper --model "$model" --input-file "$temp_dir/input.txt" --output-file "$temp_dir/speech.wav"  --volume 0.2
run_command "${player[@]}" "$temp_dir/speech.wav"
