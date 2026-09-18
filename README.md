# Agent Skills (`JoshiMinh/agent-skills`)

A curated repository of production-grade agent skills designed for modern AI coding assistants and autonomous engineering agents, including Google Antigravity, Claude Code, Cursor, GitHub Copilot, Codex, Cline, and OpenCode.

---

## Installation

You can install skills from this repository using the official [skills CLI](https://skills.sh) (`skills` / `npx skills`) or manually via Git.

### 1. Project-Level Installation (Current Workspace)

To install into the current project repository (`.agents/skills/`):

```bash
# Install a specific skill as physical files (no symlinks)
npx skills add JoshiMinh/agent-skills --skill website-compliance-auditor --copy -y

# Install all skills from the repository
npx skills add JoshiMinh/agent-skills --copy --all -y
```

### 2. Global Installation (All Workspaces)

To make skills available globally across all projects on your machine (`~/.agents/skills/`):

```bash
# Install a specific skill globally as physical files
npx skills add JoshiMinh/agent-skills --skill website-compliance-auditor --global --copy -y

# Install all skills globally
npx skills add JoshiMinh/agent-skills --global --copy --all -y
```

### 3. Targeting Specific AI Agents

You can restrict the installation to specific coding agents:

```bash
# Target Google Antigravity and Claude Code specifically
npx skills add JoshiMinh/agent-skills --skill website-compliance-auditor --agent antigravity claude-code --copy -y

# Target Cursor and GitHub Copilot
npx skills add JoshiMinh/agent-skills --skill website-compliance-auditor --agent cursor github-copilot --copy -y
```

### 4. Updating Installed Skills

```bash
# Update skills in the current project
npx skills update -p -y

# Update skills globally
npx skills update -g -y
```

### 5. Removing Skills

```bash
# Remove from the current project
npx skills remove website-compliance-auditor -y

# Remove globally
npx skills remove website-compliance-auditor --global -y
```

### 6. Manual Installation via Git / PowerShell

If you do not use `npx skills`, you can clone or copy directly into your target skills folder:

```powershell
# Clone the repository locally
git clone https://github.com/JoshiMinh/agent-skills.git

# Copy skill to project directory
Copy-Item -Recurse .\agent-skills\skills\website-compliance-auditor .\my-project\.agents\skills\

# Or copy to global Antigravity skills directory
Copy-Item -Recurse .\agent-skills\skills\website-compliance-auditor $HOME\.gemini\antigravity\skills\
```

---

## Skills Catalog

| Skill Name | Version | Description | Target Areas |
| :--- | :---: | :--- | :--- |
| [`website-compliance-auditor`](./skills/website-compliance-auditor/SKILL.md) | `2.0.0` | Comprehensive website compliance doctor auditing WCAG 2.1/2.2 AA accessibility, GDPR/CCPA privacy, cookie consent, consumer trust, and security headers. | Accessibility, Privacy, Legal, Security |

---

## Supported Agent Ecosystems

Every skill in this repository complies with the universal `SKILL.md` specification:

- **Google Antigravity / Gemini Agents**: `.gemini/antigravity/skills/` or `.agents/skills/`
- **Claude Code**: `.claude/skills/` or `.agents/skills/`
- **Cursor**: `.cursor/skills/` or `.agents/skills/`
- **GitHub Copilot**: `.github/skills/` or `.agents/skills/`
- **Codex / Cline / OpenCode**: `.agents/skills/`

---

## Adding New Skills

Contributions and new skills are welcome:

1. Create a new folder under `skills/<skill-name>/`
2. Add `skills/<skill-name>/SKILL.md` with standard YAML frontmatter:
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
3. Add the skill entry to the **Skills Catalog** table in this `README.md`.
4. Submit a Pull Request.

---

## License

[MIT](./LICENSE) (c) 2026 JoshiMinh
