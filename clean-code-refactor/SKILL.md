---
name: clean-code-refactor
description: Refactor TypeScript and React code for clarity, maintainability, and simpler state flow. Use for requested refactors, dead-code removal, complexity reduction, or React state cleanup; do not apply as a generic review of other languages.
metadata:
  author: stackbase
  version: "1.1.0"
  tags: ["Refactoring", "TypeScript", "React"]
---

# TypeScript and React Refactoring

Improve existing TypeScript or React code while preserving behavior and the project's established architecture.

---

## 1. Core Principles

1. **Minimal Abstraction over Premature Engineering**
   - Do NOT create wrappers around native libraries or well-designed primitives unless adding significant domain value.
   - Avoid "pass-through" functions or components whose only job is to forward arguments to another function.
   - Resist building generic frameworks for one-off features. Three concrete implementations are better than one premature abstraction.

2. **Complexity before size**
   - Treat file and function length as a prompt to inspect cohesion, not as a failure by itself.
   - Split code when responsibilities, change reasons, or test boundaries are genuinely distinct.
   - Do not extract pass-through helpers merely to meet a line-count target.

   Suggested size ranges below are diagnostic signals, not acceptance criteria.
   - **Functions**: Target $\le$ 30–40 lines of focused logic.
   - **Components**: Target $\le$ 150–250 lines per file. Break complex sub-sections into colocated sub-components.
   - **Files**: If a file exceeds 300 lines, evaluate splitting domain types, helpers, or hooks into separate modules.

3. **Colocation First**
   - Place types, utility helpers, and hooks near where they are used.
   - Promote to shared packages or top-level `lib/` or `packages/` ONLY when reused in $\ge$ 2 independent features or packages.

4. **Dead Code Elimination**
   - Never leave commented-out code blocks, unused imports, zombie variables, or deprecated type definitions.
   - Remove dead code immediately rather than hoarding it "for later" (Git history preserves all changes).

---

## 2. Control Flow & Complexity Reduction

- **Early Returns & Guard Clauses**: Flatten deeply nested `if/else` structures.
- **Avoid Nested Ternaries**: Never chain ternary operators (`a ? b : c ? d : e`). Use standard `if/else` or lookup tables.
- **Lookup Maps over Long Switches**: Prefer `Record<Key, Value>` or `Map` objects over 20+ line `switch/case` statements.
- **Explicit Boolean Conditions**: Avoid ambiguous truthy checks on numbers or strings (`if (count)` vs `if (count > 0)`).

---

## 3. React & State Hygiene

- **Keep State Local**: Keep state as close as possible to the leaves of the render tree to avoid unnecessary parent re-renders.
- **Derived State**: Never duplicate props or existing state into a new `useState`. Compute values during render or wrap in `useMemo` if computationally expensive.
- **Clean Effect Dependencies**: Every `useEffect` should have a single responsibility. Never synchronize state across components using chaining `useEffect` hooks.
- **Strict Typing**: Never use `any`. Use `unknown` with type guards (`is` predicates) or Zod schemas for external payloads.

---

## 4. Refactoring Checklist

- [ ] Has dead code, unused imports, or unused props been removed?
- [ ] Are all functions under 40 lines with a single clear purpose?
- [ ] Are deeply nested conditionals replaced with early return guard clauses?
- [ ] Is state minimal and non-redundant (derived values computed instead of synced)?
- [ ] Are types strict without `any` or loose type assertions (`as unknown as T`)?
