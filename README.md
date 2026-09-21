# Agent Skills

Curated, production-ready agent skills for modern AI coding assistants and autonomous engineering agents (Google Antigravity, Claude Code, Cursor, Codex, OpenCode).

Explore the live documentation and interactive catalog at **[joshiminh.github.io/agent-skills](https://joshiminh.github.io/agent-skills)**.

---

## Global live installation (Windows)

If you develop this repository locally, use the distributor rather than copying
skills. It creates directory junctions from the supported editors' global skill
directories to `skills/`, so changes to a skill are live immediately.

```powershell
# First-time setup on a machine
git clone https://github.com/JoshiMinh/agent-skills.git "$HOME\.agents\agent-skills"
Set-Location "$HOME\.agents\agent-skills"

# Preview changes; does not write anything
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-skills.ps1 -DryRun

# Reconcile all configured editor targets
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-skills.ps1

# Reconcile only selected targets
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-skills.ps1 -Target codex,antigravity,claude-code

# Fail if an install is missing, stale, or collides with an unmanaged directory
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-skills.ps1 -Check

# Restore copied skills that match this checkout exactly (including harmless line-ending changes)
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-skills.ps1 -TakeOverIdenticalCopies
```

Configured targets live in [`config/targets.json`](./config/targets.json):

- Codex and other `.agents`-compatible editors: `%USERPROFILE%\.agents\skills`
- Antigravity: `%USERPROFILE%\.gemini\config\skills`
- Claude Code: `%USERPROFILE%\.claude\skills`

For Antigravity, the distributor also maintains
`%USERPROFILE%\.gemini\config\skills.json`, explicitly registering this
repository's `skills/` directory. This avoids depending on implicit directory
discovery in IDE versions that do not scan global junctions. Restart Antigravity
after the first installation or registration change.

The default sync adds missing links, repairs incorrectly targeted managed links,
and removes stale links after a skill is deleted or renamed. It never overwrites
an existing real directory or an unmanaged link. Use `-NoPrune` to retain stale
managed links temporarily.

To update the checkout and reconcile newly added or removed skills in one command:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\update-skills.ps1
```

Use `-SkipPull` when you have already updated the repository locally.

Add another editor by adding its documented global skill directory as a target.
The script deliberately does not guess unsupported editor paths.

## Install from GitHub (copy-based)

Use the published installation when you want a versioned copy in a project, or
do not need to edit this local checkout. The [skills CLI](https://skills.sh)
selects the layout for its supported agent targets.

```powershell
# All skills in the current project
npx -y skills add JoshiMinh/agent-skills --copy --yes

# One skill in the current project
npx -y skills add JoshiMinh/agent-skills --skill clean-code-refactor --copy --yes

```

Update copied installations with:

```powershell
# Project copy
npx -y skills update --project --yes

# Global copy: use only on a machine that does not use the live junction setup above
npx -y skills update --global --yes
```

Use a copy-based project install for skills that should be committed with a
repository so teammates receive the same version. Use the junction-based global
development install above when this checkout is the source of truth. Do **not**
run `npx skills add ... --global --copy` on a development machine: it replaces
the managed junctions with independent copies. If it happens, run
`sync-skills.ps1 -TakeOverIdenticalCopies`; the script only replaces a copy when
its complete file set and contents match this checkout (allowing line-ending
normalization).

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
