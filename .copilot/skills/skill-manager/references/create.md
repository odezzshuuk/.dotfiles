# Skill Creation Process

To create a skill, follow this process in order, skipping steps only if there is a clear reason why they are not applicable.

## Step 1: Understanding the Skill with Concrete Examples

Skip this step only when the skill's usage patterns are already clearly understood.

To create an effective skill, clearly understand concrete examples of how the skill will be used. This understanding can come from either direct user examples or generated examples that are validated with user feedback.

Example questions when building an image-editor skill:

- "What functionality should the image-editor skill support? Editing, rotating, anything else?"
- "Can you give some examples of how this skill would be used?"
- "What would a user say that should trigger this skill?"

To avoid overwhelming users, avoid asking too many questions in a single message. Start with the most important questions and follow up as needed.

Conclude this step when there is a clear sense of the functionality the skill should support.

## Step 2: Planning the Reusable Skill Contents

Analyze each concrete example by:

1. Considering how to execute on the example from scratch
2. Identifying what scripts, references, and assets would be helpful when executing these workflows repeatedly

**Example analyses:**

| Skill | Query Example | Analysis | Resource |
|-------|---------------|----------|----------|
| pdf-editor | "Help me rotate this PDF" | Requires re-writing same code each time | `scripts/rotate_pdf.py` |
| frontend-webapp-builder | "Build me a todo app" | Requires same boilerplate each time | `assets/hello-world/` template |
| big-query | "How many users logged in today?" | Requires re-discovering schemas each time | `references/schema.md` |

## Step 3: Initializing the Skill

When creating a new skill from scratch, always run the `init_skill.py` script:

```bash
scripts/init_skill.py <skill-name> --path <output-directory>
```

The script:

- Creates the skill directory at the specified path
- Generates a SKILL.md template with proper frontmatter and TODO placeholders
- Creates example resource directories: `scripts/`, `references/`, and `assets/`
- Adds example files in each directory that can be customized or deleted

After initialization, customize or remove the generated files as needed.

## Step 4: Edit the Skill

Remember that the skill is being created for another instance of Agent to use. Focus on including information that would be beneficial and non-obvious.

### Start with Reusable Skill Contents

Begin implementation with the `scripts/`, `references/`, and `assets/` files identified in Step 2.

Note: This step may require user input. For example, when implementing a `brand-guidelines` skill, the user may need to provide brand assets or documentation.

Delete any example files and directories not needed for the skill.

### Update SKILL.md

**Writing Style:** Use **imperative/infinitive form** (verb-first instructions), not second person. Use objective, instructional language (e.g., "To accomplish X, do Y" rather than "You should do X").

Answer these questions in SKILL.md:

1. What is the purpose of the skill, in a few sentences?
2. When should the skill be used?
3. How should Agent use the skill? (Reference all bundled resources)

### Resource Guidelines

**Scripts (`scripts/`):**
- Include when same code is rewritten repeatedly or deterministic reliability is needed
- Token efficient, may be executed without loading into context

**References (`references/`):**
- For documentation Agent should reference while working
- Keeps SKILL.md lean, loaded only when needed
- If files are large (>10k words), include grep search patterns in SKILL.md

**Assets (`assets/`):**
- For files used in final output (templates, images, boilerplate)
- Not loaded into context, just used/copied

**Avoid duplication:** Information should live in either SKILL.md or references, not both.

## Step 5: Validate and Package

Validate the skill:

```bash
scripts/quick_validate.py <path/to/skill-folder>
```

Package for distribution:

```bash
scripts/package_skill.py <path/to/skill-folder> [output-dir]
```

The packaging script validates automatically and creates a distributable zip file.

## Step 6: Iterate

After testing the skill:

1. Use the skill on real tasks
2. Notice struggles or inefficiencies
3. Identify how SKILL.md or bundled resources should be updated
4. Implement changes and test again

For significant updates, use the update workflow in `references/update.md`.
