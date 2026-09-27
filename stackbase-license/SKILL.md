---
name: stackbase-license
description: Review StackBase repositories for project copyright policy and third-party dependency license risk. Use for requested license or intellectual-property reviews; do not treat the skill as legal advice or as a general security audit.
metadata:
  author: stackbase
  version: "1.1.0"
  tags: ["Licensing", "Compliance", "Intellectual Property"]
---

# StackBase License & IP Guardian

This skill provides engineering review guidance, not legal advice. Report uncertain, dual-licensed, custom, or weak-copyleft cases for human legal review instead of declaring them permitted or prohibited.

Standards for proprietary intellectual property protection, copyright notices, and third-party open-source license compliance across StackBase repositories.

---

## 1. Proprietary Software Notice

All source code across StackBase repositories (`WatchBase`, `RateBase`, `TaskBase`, `MarkBase`, `WriteBase`) is proprietary and confidential to **StackBase Inc.** / **TheBase Platforms LLC**.

### Standard Copyright Header
Preserve existing notices. Add a notice to new files only when the repository's current policy or templates require one; do not infer a requirement from this example alone:

```typescript
/**
 * Copyright © 2026 StackBase Inc. All rights reserved.
 * Confidential and proprietary.
 */
```

---

## 2. Third-Party Open Source Compliance

To protect StackBase's proprietary source code from accidental open-source copyleft contamination:

### Permitted Licenses (Safe for Commercial Proprietary Code)
- **MIT License** (`MIT`)
- **Apache License 2.0** (`Apache-2.0`)
- **BSD 2-Clause / 3-Clause** (`BSD-2-Clause`, `BSD-3-Clause`)
- **ISC License** (`ISC`)
- **CC0 / Unlicense** (`CC0-1.0`, `Unlicense`)

### Prohibited / Restricted Licenses (Copyleft Contamination)
- ❌ **GPL (General Public License)** (`GPL-2.0`, `GPL-3.0`)
- ❌ **AGPL (Affero General Public License)** (`AGPL-3.0`)
- ❌ **SSPL (Server Side Public License)**
- ⚠️ **LGPL / MPL**: Permitted only as dynamically linked unmodified external packages; never vendor or directly incorporate source code into StackBase repos without legal review.

---

## 3. Scope Boundary: Secrets

If license inspection reveals an obvious secret, report it immediately, but leave comprehensive secret scanning and remediation to a security review. Do not expand a licensing request into a general security audit.

---

## 4. Compliance Checklist

- [ ] Are all third-party dependencies licensed under permissive licenses (MIT, Apache 2.0, BSD, ISC)?
- [ ] Is there zero presence of viral copyleft packages (GPL/AGPL)?
- [ ] Are proprietary notices preserved in root `LICENSE` and documentation?
- [ ] Are all sensitive credentials, database URLs, and API tokens loaded strictly via environment variables?
