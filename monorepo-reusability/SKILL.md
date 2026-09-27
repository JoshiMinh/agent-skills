---
name: monorepo-reusability
description: Review or refactor JavaScript and TypeScript monorepo boundaries, shared packages, cross-platform code, and workspace dependencies. Use when code is shared across two or more real consumers; do not force a monorepo or extract one-off code.
metadata:
  author: stackbase
  version: "1.1.0"
  tags: ["Monorepo", "Architecture", "Code Sharing"]
---

# Monorepo Package Reusability & Cross-Platform Architecture

Engineering manual for designing modular, DRY, and cross-platform shared packages across StackBase monorepo projects.

---

## 1. Monorepo Layering Matrix

First inspect the repository's existing workspace layout, consumers, build tools, and public APIs. Use the following graph as a common StackBase pattern, not as a mandatory shape:

```
[apps/web]      [apps/mobile]      [apps/extension]
    │                │                   │
    ▼                ▼                   ▼
[@<repo>/ui]   [@<repo>/supabase]   [@<repo>/auth]
    │                │                   │
    └────────────────┼───────────────────┘
                     ▼
             [@<repo>/utils]
                     ▼
             [@<repo>/types]
```

1. **`@<repo>/types` (Level 0 - Foundation, when independently reused)**:
   - Pure TypeScript types and interfaces.
   - Zero runtime JavaScript dependencies.
   - No React, Node.js, or platform-specific dependencies.

2. **`@<repo>/utils` (Level 1 - Pure Logic)**:
   - Platform-agnostic pure helper functions (formatting, date calculations, validation, math).
   - Safe to run in any JS environment (Browser, Node.js, Cloudflare Workers, React Native, Chrome Extension Service Worker).

3. **`@<repo>/ui` (Level 2 - Design System Primitives)**:
   - Reusable UI component contracts and design tokens.
   - Web implementations use Radix UI / Tailwind CSS; platform-specific variations are cleanly abstracted.

4. **`@<repo>/supabase` / `@<repo>/auth` (Level 2 - Backend & Data Client)**:
   - Typed data queries, client factories, and authentication state helpers.

5. **`apps/*` (Level 3 - Product Surfaces)**:
   - Product-specific routes, pages, and feature composition.

---

## 2. Cross-Platform Sharing Rules

- **Zero Node.js Built-in Leaks**: Shared packages must never import Node-only modules (`fs`, `path`, `crypto`, `os`) unless scoped strictly to server-only entry points.
- **Universal Code Isolation**: Isolate web-specific DOM APIs (`window`, `document`, `localStorage`) and mobile-specific APIs (`AsyncStorage`, `SecureStore`) behind standard interface adapters.
- **No Circular Workspace Dependencies**: A package must NEVER import from a package that depends on it.
- **Explicit Exports**: Always define explicit entry points in each package's `package.json` `exports` map rather than allowing arbitrary deep path imports.

---

## 3. Package Reusability Checklist

Recommend extraction only when at least two independent consumers need the same stable behavior. Preserve framework-specific code in its owning app unless sharing produces a clearer API and lower total maintenance cost.

- [ ] Does the shared package have a single, well-defined responsibility?
- [ ] Are types placed in `@<repo>/types` without bundling unnecessary runtime dependencies?
- [ ] Are workspace dependencies pinned using `workspace:*` in `package.json`?
- [ ] Is there zero circular dependency between packages or applications?
- [ ] Can the shared utility run cleanly across Web, Mobile (Expo), and Extension targets?
