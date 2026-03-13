---
name: skill-manager
description: Guide for creating and updating skills. This skill should be used when users want to create a new skill or modify an existing skill that extends Agent's capabilities with specialized knowledge, workflows, or tool integrations.
license: Complete terms in LICENSE.txt
---

# Skill Manager

This skill provides guidance for creating and updating skills.

## About Skills

Skills are modular, self-contained packages that extend Agent's capabilities by providing specialized knowledge, workflows, and tools. They transform Agent from a general-purpose agent into a specialized agent equipped with procedural knowledge.

### What Skills Provide

1. **Specialized workflows** - Multi-step procedures for specific domains
2. **Tool integrations** - Instructions for working with specific file formats or APIs
3. **Domain expertise** - Company-specific knowledge, schemas, business logic
4. **Bundled resources** - Scripts, references, and assets for complex and repetitive tasks

### Anatomy of a Skill

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter: name, description (required)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/     - Executable code (Python/Bash/etc.)
    ├── references/  - Documentation loaded into context as needed
    └── assets/      - Files used in output (templates, icons, etc.)
```

### Progressive Disclosure

Skills use a three-level loading system:

1. **Metadata** - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<5k words)
3. **Bundled resources** - As needed (unlimited)

## Workflow Selection

Based on the user's request, determine the appropriate workflow:

| User Intent                   | Workflow | Reference              |
| ----------------------------- | -------- | ---------------------- |
| Create a new skill            | Creation | `references/create.md` |
| Update/improve existing skill | Update   | `references/update.md` |

## Skill Generalization

When updating a skill based on user feedback from specific use cases, extract generalizable principles rather than tool-specific patterns. This increases the skill's reusability across domains.

### Process

1. **Identify patterns**: Review feedback and changes across multiple examples or domains
2. **Extract principles**: Determine which patterns are domain-agnostic vs. domain-specific
3. **Generalize**: State principles in abstract terms applicable to similar situations
4. **Update skill**: Add generalized guidance to the skill with concrete examples

### Example

❌ Non-generalizable update:
```
// skill-manager SKILL.md
When updating the Rust conditional compilation note, avoid repeating the same #[cfg] pattern three times.
```

✅ Generalizable update:
```
// skill-manager SKILL.md
## Avoid Redundant Examples

When documenting a feature with multiple similar configurations (e.g., platform targets, feature flags):
- Show ONE representative example demonstrating the pattern
- Use `not()` or positive/negative pairs to show the contrast
- Let readers generalize to other cases

This keeps notes concise and focused on the concept, not permutations.
```

Then update dependent skills:

```
// note-writing SKILL.md
- **One representative example is enough**: Avoid repetitive examples showing the same pattern multiple times.
```

### When to Update Skills After User Feedback

Update the skill (not just the specific note) when:
- The feedback reveals a gap in the skill's guidance
- The pattern is applicable to multiple note types or domains
- Future agents should benefit from this learned principle

Update just the note (not the skill) when:
- The issue is specific to that one note's content
- The feedback is about factual accuracy, not process/structure

## Available Scripts

All scripts are in `scripts/` directory:

| Script              | Purpose                        | Usage                                                  |
| ------------------- | ------------------------------ | ------------------------------------------------------ |
| `init_skill.py`     | Initialize new skill template  | `scripts/init_skill.py <name> --path <dir>`            |
| `quick_validate.py` | Validate skill structure       | `scripts/quick_validate.py <skill-folder>`             |
| `package_skill.py`  | Package skill for distribution | `scripts/package_skill.py <skill-folder> [output-dir]` |

## Quick Reference

### SKILL.md Requirements

- **Metadata**: `name` and `description` in YAML frontmatter (required)
- **Description**: Use third-person ("This skill should be used when...")
- **Writing style**: Imperative/infinitive form (verb-first instructions)

### Bundled Resources Guidelines

- **scripts/**: For deterministic, repeatable code tasks
- **references/**: For documentation Agent references while working
- **assets/**: For files used in output (not loaded into context)

### Validation Checklist

1. `name` field matches skill directory name
2. `description` explains when to use the skill
3. All referenced files exist
4. No broken links to resources
