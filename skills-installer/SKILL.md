---
name: skills-installer
description: Audit all local project repositories and recommend project-scoped or remote Codex skills; use when comparing skill coverage across projects or planning skill installation.
---

# Skills Installer

Audit projects first. Recommend skills before changing any project or global skill directory.

## Audit scope

- Discover repositories beneath the user's Projects directory, including the current project, by locating `.git` directories.
- For each repository, inspect its top-level documentation and configuration that indicates its stack, tooling, and workflows. Check project-local skills in `.agents/skills` and `.codex/skills` when present.
- Inspect available user-level skills only as candidates to copy into a project. Do not treat their presence as a reason to install them globally.
- Report each project's likely needs, already-installed local skills, and a short list of recommended project-local skills with a specific reason.

## Recommendations

- Prefer a project-local skill when it serves one repository or one technology stack. Use the repository's existing local-skill convention; if neither `.agents/skills` nor `.codex/skills` exists, ask the user which location they prefer before installing.
- Include relevant remote skills as suggestions when they would materially help the project. State the source, purpose, and whether installation may require network access.
- Do not recommend a skill merely because it exists. Tie every recommendation to an observed project need.
- Keep global recommendations separate. A globally installed skill must be broadly useful across multiple repositories.

## Required questions before installation

After presenting recommendations, ask:

1. Which project-local recommendations should be installed, if any?
2. Which remote skill recommendations should be installed, if any?
3. Should any skills also be installed globally? List only the cross-project candidates and make clear that declining leaves installation project-scoped.

Do not install, copy, overwrite, or remove a skill until the user answers these questions. Confirm the exact destination and source immediately before a write.

## Installation and verification

- Install approved skills only into the chosen project's local skill directory unless the user separately approved global installation.
- Preserve existing project skills and do not overwrite an existing skill without explicit approval.
- For remote skills, use the approved installation workflow and report the exact source and destination.
- After installation, verify that each expected `SKILL.md` exists and summarize the changes by project.
