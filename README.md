# Agent Skills

Curated, production-ready agent skills for modern AI coding assistants and autonomous engineering agents (Google Antigravity, Claude Code, Cursor, Codex, OpenCode).

Explore the live documentation and interactive catalog at **[joshiminh.github.io/agent-skills](https://joshiminh.github.io/agent-skills)**.

---

## Installation

Skills can be installed into any workspace using the official [skills CLI](https://skills.sh):

```bash
# Install all skills into your project
npx skills add JoshiMinh/agent-skills --copy -y

# Install a specific skill
npx skills add JoshiMinh/agent-skills --skill <skill-name> --copy -y

# Install globally across all local projects
npx skills add JoshiMinh/agent-skills --global --copy -y
```

---

## Skill Updates

To sync installed skills in any repository with the latest upstream revisions:

```bash
# Update all project skills
npx skills update -p -y

# Update globally installed skills
npx skills update -g -y
```

---

## Contributing

1. Create a directory under `skills/<skill-name>/`.
2. Add `SKILL.md` with standard YAML frontmatter:
   ```yaml
   ---
   name: your-skill-name
   description: "Precise summary and trigger keywords."
   metadata:
     author: your-username
     version: "1.0.0"
   ---

   # Skill Title
   ...
   ```
3. Submit a Pull Request.

---

## License

[MIT](./LICENSE) (c) 2026 JoshiMinh
