# Skill Update Process

To update a skill, follow this process in order, skipping steps only if there is a clear reason why they are not applicable.

## Step 1: Understand the Current Skill State

Before making changes, thoroughly understand the existing skill:

1. **Read SKILL.md** - Understand the skill's purpose, workflows, and instructions
2. **Review bundled resources** - Examine all scripts, references, and assets
3. **Identify the skill's scope** - Understand what tasks the skill is designed to handle

Key questions:

- What is the skill's current purpose and scope?
- What bundled resources exist and how are they used?
- What workflows does the skill currently support?

## Step 2: Gather Update Requirements

Clarify what changes are needed based on update type:

| Update Type | Key Questions |
|-------------|---------------|
| Bug fix | What issue occurred? Expected vs actual behavior? Under what conditions? |
| Enhancement | What new functionality? How does it fit existing scope? Concrete examples? |
| Refactoring | What's inefficient or unclear? What improvements would help? |

To avoid overwhelming users, ask focused questions relevant to the specific update type.

## Step 3: Plan the Changes

1. **Identify affected files:**
   - SKILL.md (instructions, metadata)
   - Scripts in `scripts/`
   - References in `references/`
   - Assets in `assets/`

2. **Assess impact on:**
   - Existing workflows
   - Other bundled resources
   - Skill triggering (if metadata changes)

3. **Plan implementation order:**
   - Update dependencies first (scripts/references used by SKILL.md)
   - Update SKILL.md to reflect new resources
   - Remove obsolete files last

## Step 4: Implement the Changes

### Updating SKILL.md

**Writing Style:** Maintain **imperative/infinitive form** (verb-first instructions).

- **Metadata updates**: Ensure `name` and `description` accurately reflect capabilities
- **Instruction updates**: Keep clear, concise, and actionable
- **Resource references**: Update if bundled resources change
- **Avoid duplication**: Information in either SKILL.md or references, not both

### Updating Scripts (`scripts/`)

- Preserve existing functionality unless explicitly changing it
- Add clear comments for new or modified logic
- Test scripts independently before integration
- Update SKILL.md if script usage or arguments change

### Updating References (`references/`)

- Keep documentation current and accurate
- Remove outdated information
- Update SKILL.md if references are added or removed
- Consider splitting large files if they exceed 10k words

### Updating Assets (`assets/`)

- Replace files with updated versions as needed
- Update SKILL.md if asset paths or usage changes
- Remove unused assets to keep the skill lean

## Step 5: Validate the Updates

**Manual validation checklist:**

1. **Metadata**: `name` matches directory, `description` uses third-person
2. **Content**: Clear instructions, all referenced files exist
3. **Resources**: Scripts functional, references accurate, assets present

**Automated validation:**

```bash
scripts/quick_validate.py <path/to/skill-folder>
```

## Step 6: Package (Optional)

If the skill needs distribution after updates:

```bash
scripts/package_skill.py <path/to/skill-folder> [output-dir]
```

## Common Update Scenarios

### Adding New Functionality

1. Understand new use cases with concrete examples
2. Identify required new resources
3. Create the new resources
4. Update SKILL.md to incorporate new functionality
5. Validate and test

### Fixing a Bug

1. Reproduce and understand the issue
2. Identify root cause (instructions, scripts, or references)
3. Implement the fix
4. Test with the original failing scenario
5. Validate no regressions

### Improving Performance

1. Identify inefficiencies (redundant instructions, large files, unclear workflows)
2. Refactor for clarity and efficiency
3. Move detailed content to references if SKILL.md is too long
4. Remove unused resources
5. Validate skill still functions correctly

### Updating Metadata

1. Review current `name` and `description`
2. Update to better reflect skill capabilities
3. Ensure description explains when skill should be used
4. Validate skill triggers correctly for intended use cases
