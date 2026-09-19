# Agent Skills (`JoshiMinh/agent-skills`)

A curated repository of production-grade agent skills designed for modern AI coding assistants and autonomous engineering agents, including Google Antigravity, Claude Code, Cursor, GitHub Copilot, Codex, Cline, and OpenCode.

---

## Command Reference & Manual

Skills in this repository can be installed, updated, and managed using the official [skills CLI](https://skills.sh) (`npx skills`) or via direct file copy.

### 1. Installation

#### Project-Level Installation (Current Workspace)
Installs the skill into the current repository's `.agents/skills/` directory:

```bash
# Install a specific skill as physical files (no symlinks)
npx skills add JoshiMinh/agent-skills --skill website-compliance-auditor --copy -y

# Install all skills from the repository into the current project
npx skills add JoshiMinh/agent-skills --copy --all -y
```

#### Global Installation (Machine-Wide)
Installs into your user directory (`~/.agents/skills/`), accessible across all projects:

```bash
# Install a specific skill globally
npx skills add JoshiMinh/agent-skills --skill website-compliance-auditor --global --copy -y

# Install all skills globally
npx skills add JoshiMinh/agent-skills --global --copy --all -y
```

#### Targeting Specific Agents
By default, skills are configured for all supported agents found on your machine. You can restrict installation to specific agents:

```bash
# Target Google Antigravity and Claude Code only
npx skills add JoshiMinh/agent-skills --skill website-compliance-auditor --agent antigravity claude-code --copy -y

# Target Cursor and GitHub Copilot only
npx skills add JoshiMinh/agent-skills --skill website-compliance-auditor --agent cursor github-copilot --copy -y
```

---

### 2. Updating Skills Across Projects

When you make modifications to skills inside `JoshiMinh/agent-skills` and push them to GitHub, consuming projects can sync the latest changes with CLI commands:

#### Step 1: Push Changes from the Source Repo
```bash
cd ~/.agents/agent-skills
git add .
git commit -m "feat(skill-name): update rules and guidelines"
git push origin main
```

#### Step 2: Sync in Consuming Projects
Navigate to any project repository that uses the skills and run:

```bash
# Update all installed skills in the current project to their latest upstream version
npx skills update -p -y

# Or update a specific skill by name
npx skills update website-compliance-auditor -y

# Force-reinstall/overwrite with the latest version from GitHub
npx skills add JoshiMinh/agent-skills --skill website-compliance-auditor --copy -y
```

#### Step 3: Sync Global Skills
```bash
# Update all globally installed skills to their latest upstream versions
npx skills update -g -y
```

---

### 3. Listing & Inspecting Installed Skills

```bash
# List skills installed in the current project
npx skills list

# List globally installed skills
npx skills list -g

# Search for skills interactively
npx skills find
```

---

### 4. Removing Skills

```bash
# Remove a skill from the current project
npx skills remove website-compliance-auditor -y

# Remove a skill globally
npx skills remove website-compliance-auditor --global -y
```

---

### 5. Manual Installation (Without CLI)

If working in an environment without Node.js / `npx`:

```powershell
# Clone the repository locally
git clone https://github.com/JoshiMinh/agent-skills.git

# Copy skill to a project directory
Copy-Item -Recurse .\agent-skills\skills\website-compliance-auditor .\my-project\.agents\skills\

# Copy to Antigravity global skills directory
Copy-Item -Recurse .\agent-skills\skills\website-compliance-auditor $HOME\.gemini\antigravity\skills\
```

---

## Skills Catalog

| Skill Name | Version | Description | Target Areas |
| :--- | :---: | :--- | :--- |
| [`clean-code-refactor`](./skills/clean-code-refactor/SKILL.md) | `1.0.0` | Best practices for clean, minimal, maintainable TypeScript/React code: dead code elimination, guard clauses, shallow nesting, and modular file budgets. | Refactoring, Clean Code, Performance |
| [`monorepo-reusability`](./skills/monorepo-reusability/SKILL.md) | `1.0.0` | Guidelines for monorepo package architecture, cross-platform code sharing (Web, Expo, Extension), DRY abstractions, and workspace dependency management. | Architecture, Monorepo, Cross-Platform |
| [`stackbase-license`](./skills/stackbase-license/SKILL.md) | `1.0.0` | Proprietary software licensing, StackBase LLC copyright compliance, third-party OSS dependency auditing (blocking viral copyleft), and secret isolation. | Licensing, Compliance, Security |
| [`website-compliance-auditor`](./skills/website-compliance-auditor/SKILL.md) | `2.0.0` | Comprehensive website compliance doctor auditing WCAG 2.1/2.2 AA accessibility, GDPR/CCPA privacy, cookie consent, consumer trust, and security headers. | Accessibility, Privacy, Legal, Security |

---

## Supported Agent Ecosystems

Every skill in this repository conforms to the universal `SKILL.md` format:

- **Google Antigravity / Gemini Agents**: `.gemini/antigravity/skills/` or `.agents/skills/`
- **Claude Code**: `.claude/skills/` or `.agents/skills/`
- **Cursor**: `.cursor/skills/` or `.agents/skills/`
- **GitHub Copilot**: `.github/skills/` or `.agents/skills/`
- **Codex / Cline / OpenCode**: `.agents/skills/`

---

## Adding New Skills

Contributions and new skills are welcome:

1. Create a new directory under `skills/<skill-name>/`
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
4. Open a Pull Request.

---

## License

[MIT](./LICENSE) (c) 2026 JoshiMinh
