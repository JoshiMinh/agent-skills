# Skills Installer

`skills-installer` audits all local project repositories and recommends skills for each project.

It keeps recommendations project-scoped by default, suggests relevant remote skills, and asks before any installation. Global installation is always a separate decision.

## Workflow

1. Discover repositories and their stacks, tooling, documentation, and local skills.
2. Compare observed needs with available local and remote skills.
3. Present project-specific recommendations and reasons.
4. Ask which local and remote skills to install, then separately ask about global candidates.
5. Install only approved skills and verify their `SKILL.md` files.
