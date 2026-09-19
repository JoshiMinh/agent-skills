---
name: stackbase-license
description: "Proprietary software licensing, StackBase LLC copyright compliance, third-party open-source dependency auditing, and intellectual property protection across StackBase repositories."
metadata:
  author: stackbase
  version: "1.0.0"
---

# StackBase License & IP Guardian

Standards for proprietary intellectual property protection, copyright notices, and third-party open-source license compliance across StackBase repositories.

---

## 1. Proprietary Software Notice

All source code across StackBase repositories (`WatchBase`, `RateBase`, `TaskBase`, `MarkBase`, `WriteBase`) is proprietary and confidential to **StackBase LLC** / **TheBase Platforms LLC**.

### Standard Copyright Header
When creating new source files, major modules, or standalone packages, include the proprietary notice comment at the top where applicable:

```typescript
/**
 * Copyright © 2026 StackBase LLC. All rights reserved.
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

## 3. Secret & Credential Leakage Protection

- **No Hardcoded Secrets**: Never commit API keys, service role keys, webhook signing secrets, database passwords, or private SSH keys.
- **Environment Isolation**: Always use `.env.example` templates with empty placeholders (`SUPABASE_SERVICE_ROLE_KEY=`) and keep actual secrets inside `.env.local` (which must be ignored in `.gitignore`).
- **Client Bundle Safety**: Only environment variables explicitly prefixed with public markers (e.g. `NEXT_PUBLIC_*`, `EXPO_PUBLIC_*`) are exposed to client browsers. Never expose backend admin credentials to the client.

---

## 4. Compliance Checklist

- [ ] Are all third-party dependencies licensed under permissive licenses (MIT, Apache 2.0, BSD, ISC)?
- [ ] Is there zero presence of viral copyleft packages (GPL/AGPL)?
- [ ] Are proprietary notices preserved in root `LICENSE` and documentation?
- [ ] Are all sensitive credentials, database URLs, and API tokens loaded strictly via environment variables?
