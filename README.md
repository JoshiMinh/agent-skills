# 🧠 Agent Skills (`@JoshiMinh/agent-skills`)

A curated repository of high-impact, production-grade agent skills designed for modern AI coding assistants and autonomous engineering agents (including **Google Antigravity**, **Claude Code**, **Cursor**, **GitHub Copilot**, **Codex**, **Cline**, and more).

---

## 📦 Quick Installation

Install any skill instantly into your project or globally using the official [skills CLI](https://skills.sh):

### Project-Level Installation (Recommended)
```bash
# Install the website-compliance-auditor skill into your current repository (as physical copies)
npx skills add JoshiMinh/agent-skills --skill website-compliance-auditor --copy -y

# Or install all available skills from this repository
npx skills add JoshiMinh/agent-skills --copy --all -y
```

### Global Installation (Available across all workspaces)
```bash
npx skills add JoshiMinh/agent-skills --skill website-compliance-auditor --global --copy -y
```

---

## 📚 Skills Catalog

| Skill Name | Version | Description | Target Areas |
| :--- | :---: | :--- | :--- |
| [`website-compliance-auditor`](./skills/website-compliance-auditor/SKILL.md) | `2.0.0` | Comprehensive website compliance doctor auditing WCAG 2.1/2.2 AA accessibility, GDPR/CCPA privacy, cookie consent, consumer trust, and security headers. | Accessibility, Privacy, Legal, Security |

---

## 🛠 Supported Agent Ecosystems

Every skill in this repository adheres to the standard `SKILL.md` format:

- **Google Antigravity / Gemini Agents** (`.gemini/antigravity/skills/` or `.agents/skills/`)
- **Claude Code** (`.claude/skills/` or `.agents/skills/`)
- **Cursor** (`.cursor/skills/` or `.agents/skills/`)
- **GitHub Copilot** (`.github/skills/` or `.agents/skills/`)
- **Codex / Cline / OpenCode** (`.agents/skills/`)

---

## 🤝 Adding New Skills

Contributions and new skills are welcome! To add a new skill to this repository:

1. Create a new directory under `skills/<skill-name>/`
2. Define `skills/<skill-name>/SKILL.md` with standard YAML frontmatter:
   ```yaml
   ---
   name: your-skill-name
   description: "Precise description and trigger keywords."
   metadata:
     author: your-username
     version: "1.0.0"
   ---

   # Skill Title
   ...
   ```
3. Update the **Skills Catalog** table in this `README.md`.
4. Open a Pull Request!

---

## 📄 License

[MIT](./LICENSE) © [JoshiMinh](https://github.com/JoshiMinh)
