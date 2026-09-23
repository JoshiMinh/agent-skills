---
name: website-compliance-auditor
description: "Comprehensive website compliance and audit skill covering WCAG 2.1/2.2 AA accessibility, GDPR/CCPA privacy and cookie consent, consumer protection, legal terms, web security headers, and trust verification. Triggers for: website audits, accessibility checks (a11y), contrast ratios, keyboard navigation, cookie consent banners, privacy policies, terms of service, refund policies, tracking scripts audit, and security headers (CSP/HSTS)."
metadata:
  author: JoshiMinh
  version: "2.0.0"
---

# Website Compliance & Accessibility Auditor

A production-grade audit skill to evaluate websites and web applications for **Accessibility (WCAG 2.1 & 2.2 AA)**, **Privacy & Data Protection (GDPR / CCPA / ePrivacy)**, **Consumer Trust & Legal Compliance (Terms, Refunds, Business Identity)**, and **Web Security Hygiene (Headers & CSP)**.

---

## Audit Principles

1. **Practical & Context-Aware**: Only evaluate checks that apply to the current website (e.g., do not flag missing refund policies on open-source landing pages or non-commercial blogs).
2. **Actionable Remediation**: Every warning or failure must include a precise explanation and a copy-pasteable code fix (React/Next.js, HTML, CSS/Tailwind, or config).
3. **Hybrid Verification**: Combine static code analysis (JSX semantics, Next.js config, Tailwind classes) with live DOM/network inspection (via Chrome DevTools MCP or browser testing).

---

## 1. Core Accessibility Checks (Always Review)

Every public page and authenticated view must satisfy these fundamental WCAG 2.1 & 2.2 AA requirements:

### A. Colour Contrast (WCAG 1.4.3 & 1.4.11)
- **Normal Text (< 18pt / < 24px regular, or < 14pt / < 18.66px bold)**: Minimum **4.5:1** contrast ratio against its background.
- **Large Text (≥ 18pt / 24px, or ≥ 14pt / 18.66px bold)**: Minimum **3.0:1** contrast ratio.
- **UI Components & Graphical Objects (Icons, Borders, Focus Rings)**: Minimum **3.0:1** contrast ratio against adjacent colors.
- **Remediation**: Use semantic contrast tokens (e.g., `text-foreground` `#f5f5f5` on `bg-background` `#0f0f0f` -> 18.2:1 ratio). Avoid low-contrast grays on dark surfaces.

### B. Alt Text & Image Semantics (WCAG 1.1.1)
- **Meaningful Images / Graphics**: Provide concise, descriptive `alt` text explaining the image's content or function.
- **Decorative Images & Backgrounds**: Mark as decorative using `alt=""` or `aria-hidden="true"` so screen readers skip them.
- **Functional Images (Icons inside buttons/links)**: Use `aria-label` on the parent interactive element or include `<span className="sr-only">Description</span>`.

### C. Keyboard Accessibility & Navigation (WCAG 2.1.1, 2.4.7, 2.4.11)
- **Full Keyboard Navigation**: All interactive elements (buttons, links, inputs, dropdowns, modal dialogs) must be reachable and operable using `Tab`, `Shift+Tab`, `Enter`, `Space`, and arrow keys.
- **Visible Focus Rings (WCAG 2.4.7 / 2.4.11)**: Never use `outline-none` without an explicit focus-visible replacement (e.g., `focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2`). Focus indicator must have at least 3:1 contrast against adjacent background.
- **No Keyboard Traps (WCAG 2.1.2)**: Focus must move naturally into and out of all sub-components (menus, modals, side drawers). Modals must trap focus while open and release focus upon `Escape` or close.
- **Skip Links (WCAG 2.4.1)**: Provide a skip-to-content link (`<a href="#main-content" className="sr-only focus:not-sr-only">Skip to main content</a>`) for long navigation headers.

### D. Clear Button & Link Labels (WCAG 2.4.4, 2.4.6, 4.1.2)
- **Accessible Names**: Avoid icon-only buttons without accessible names (e.g., `<button><svg/></button>` is a FAIL; use `<button aria-label="Close dialog"><svg/></button>`).
- **Descriptive Link Text**: Avoid vague anchor labels like "Click here", "Learn more", or "Read more". Use context-rich text (e.g., "Read more about our pricing plans" or use `aria-label`).

### E. Target Size & Touch Targets (WCAG 2.2 - SC 2.5.8)
- **Minimum Interactive Target Size**: Interactive touch/click targets must be at least **24x24px** (WCAG 2.2 AA minimum) with adequate spacing, and preferably **44x44px** (recommended for mobile interfaces).

### F. Semantic Landmarks & Hierarchy (WCAG 1.3.1)
- **Landmarks**: Ensure pages use `<header>`, `<nav>`, `<main id="main-content">`, `<aside>`, and `<footer>`.
- **Heading Order**: Strictly maintain hierarchical heading structure (`<h1>` -> `<h2>` -> `<h3>`) without skipping levels for visual styling.

---

## 2. Privacy & Data Protection Checks (GDPR, CCPA/CPRA, ePrivacy)

Evaluate these based on the data collection and tracking patterns of the application:

### A. Privacy Policy Completeness & Accessibility
- **Presence**: A clear link to the Privacy Policy must be easily accessible from all pages (typically in the global footer).
- **Core Disclosures**:
  - Identity and contact information of the data controller.
  - Categories of personal data collected (account info, IP addresses, cookies, payment info).
  - Legal basis for processing (consent, contract fulfillment, legitimate interest).
  - Data retention duration and third-party data sharing / subprocessors list.
  - User rights (access, rectification, erasure/deletion, portability, withdrawal of consent).

### B. Data Minimization (GDPR Art. 5(1)(c))
- Forms and user onboarding must only request information strictly necessary for the immediate function.
- Optional fields must be explicitly marked as optional.

### C. Cookie Consent & Consent Mode v2
- **Non-Essential Cookies / Tracking**: If analytics (GA4, PostHog, Mixpanel), marketing pixels (Meta, TikTok), or session recording (Hotjar, Clarity) are used:
  - An explicit opt-in Cookie Consent banner is required before firing non-essential scripts.
  - **No Pre-Ticked Checkboxes**: Non-essential cookies must be off by default.
  - **Equal Choice**: Rejecting cookies must be as easy as accepting them (e.g., "Reject All" button alongside "Accept All").
  - **Google Consent Mode v2**: Ensure default signals (`analytics_storage='denied'`, `ad_storage='denied'`) are established before gtag/GTM initialization.

### D. Tracking & Analytics Review
- **Default-Deny Execution**: Verify that telemetry and tracking scripts do not execute or drop cookies prior to affirmative user consent.
- **PII in URLs**: Ensure sensitive personal identifiable information (emails, tokens, passwords) is never transmitted in query strings or page URLs where analytics or server logs capture them.

### E. Form Consent & Lead Capture (GDPR Art. 7)
- Sign-up forms, newsletter inputs, and contact forms must include clear consent language and links to the Privacy Policy.
- Newsletter subscriptions must not be bundled silently into general account registration without explicit notice.

### F. Third-Party Embeds & Sandboxing
- Third-party widgets (YouTube embeds, Google Maps, social widgets, Intercom/Zendesk chat):
  - Use `loading="lazy"` and `sandbox` attributes on iframes where appropriate.
  - Prefer privacy-enhanced modes (e.g., `youtube-nocookie.com`) or click-to-load placeholders before establishing connections to third-party tracking domains.

---

## 3. Consumer Trust & Legal Compliance

Evaluate these when commercial features, accounts, or user content are present:

### A. Terms & Conditions / Terms of Service
- Mandatory if users:
  - Create accounts or authenticate.
  - Subscribe to paid services or make purchases.
  - Upload user-generated content (reviews, media, comments).
- Must define acceptable use, account termination rules, IP ownership, and limitation of liability.

### B. Refund & Cancellation Policy
- Required if products, digital goods, subscriptions, or paid services are offered.
- Must clearly detail:
  - Refund eligibility and cooling-off periods (e.g., 14-day EU statutory right of withdrawal).
  - Cancellation procedures and subscription renewal policies.
  - Processing timelines for refunds.

### C. Business Identity & Impressum (EU / Commercial Laws)
- Commercial/business websites must provide verified contact and identity information:
  - Legal business name and physical mailing address.
  - Direct electronic contact (e.g., `support@domain.com` or verified contact form).
  - Business registration / VAT ID / Company number (if applicable in commercial jurisdictions like EU/UK).

### D. Anti-Deceptive Patterns & Social Proof Verification
- **Misleading / Unsupported Claims**: Avoid unverified superlatives ("#1 App in the World", "Guaranteed 1000% returns") without verifiable substantiation.
- **Testimonial & Review Authenticity (FTC Compliance)**: Reviews and testimonials must represent genuine customer experiences. Disclose paid endorsements or sponsored reviews.
- **No Dark Patterns**: Avoid countdown timers with fake expiration, pre-selected recurring billing addons, or disguised ads.

---

## 4. Web Security Headers & Network Hygiene

Verify HTTP response headers and security configs (e.g., in `next.config.ts`, Cloudflare, or edge middleware):

| Security Header | Recommended Configuration | Purpose |
| :--- | :--- | :--- |
| **Content-Security-Policy (CSP)** | `default-src 'self'; script-src 'self' 'unsafe-inline'; object-src 'none';` | Mitigates Cross-Site Scripting (XSS) and code injection. |
| **Strict-Transport-Security (HSTS)** | `max-age=63072000; includeSubDomains; preload` | Enforces HTTPS connections. |
| **X-Frame-Options** | `DENY` or `SAMEORIGIN` | Protects against UI redressing and clickjacking. |
| **X-Content-Type-Options** | `nosniff` | Prevents MIME-type sniffing. |
| **Referrer-Policy** | `strict-origin-when-cross-origin` | Protects sensitive URL paths from leaking to third parties. |
| **Permissions-Policy** | `camera=(), microphone=(), geolocation=()` | Restricts browser hardware access to authorized domains only. |

---

## 5. Audit Workflow & Execution Guide

When auditing a page, component, or repository, follow this hybrid methodology:

```
[1. Codebase Scan] ──────► [2. Live Browser / DevTools] ──────► [3. Compliance Report]
- Check JSX semantics       - Inspect DOM a11y tree             - Output PASS / WARN / FAIL
- Check Next.js headers     - Test keyboard tab navigation      - Provide exact code fixes
- Check Footer legal links  - Audit cookies & network calls     - Prioritize by severity
```

### Static Code Check Commands
- Search for icon buttons without accessible names:
  ```bash
  grep -rn "<button" --include="*.tsx"
  ```
- Search for missing image alt tags:
  ```bash
  grep -rn "<img" --include="*.tsx"
  ```
- Search for outline suppression:
  ```bash
  grep -rn "outline-none" --include="*.tsx"
  ```

---

## 6. Standardized Audit Output Template (CLI Doctor Format)

Format all audit results using this high-visibility, structured CLI Doctor format:

```markdown
# 🩺 Website Compliance Doctor: [Target Page / Component]

┌─────────────────────────────────────────────────────────────┐
│  Overall Status:  ✔ PASS (Compliant)  |  Health Score: 100% │
│  Passed: [Count]  Warnings: [Count]   |  Critical Fails: 0  │
└─────────────────────────────────────────────────────────────┘

---

### 1. Accessibility (WCAG 2.1 & 2.2 AA)
- ✔ **PASS**  `Colour Contrast` (WCAG 1.4.3)
  - **Details**: 18.2:1 contrast ratio (`text-foreground` on `bg-background`) exceeds WCAG AAA minimum.
  - **Location**: `apps/web/app/globals.css#L10`

- ⚠ **WARN**  `Skip to Main Content` (WCAG 2.4.1)
  - **Details**: Keyboard users must tab through header navigation on every page view.
  - **Location**: `apps/web/app/layout.tsx#L84`
  - **Remediation**:
    ```tsx
    <a href="#main-content" className="sr-only focus:not-sr-only focus:fixed focus:top-4 focus:left-4 focus:z-50 ...">
      Skip to main content
    </a>
    ```

### 2. Privacy & Data Protection (GDPR, CCPA/CPRA, ePrivacy)
- ✔ **PASS**  `Privacy Policy Disclosures` (GDPR Art. 13/14)
  - **Details**: Data controller contact and account deletion rights are explicitly disclosed.
  - **Location**: `apps/web/app/(account)/privacy/page.tsx`

- ✔ **PASS**  `Sign-Up Consent Disclosure` (GDPR Art. 7)
  - **Details**: Terms of Service and Privacy Policy links rendered under signup submission button.
  - **Location**: `apps/web/components/auth/auth-dialog.tsx#L427`

### 3. Consumer Trust & Legal Compliance
- ✔ **PASS**  `Terms of Service & Licensing`
  - **Details**: Clear terms on acceptable use, account security, and IP attribution.
  - **Location**: `apps/web/app/(account)/terms/page.tsx`

- ✔ **PASS**  `Refund Policy Disclosure`
  - **Details**: 14-day refund window and support contact email explicitly stated in Upgrade FAQ.
  - **Location**: `apps/web/app/(account)/upgrade/_components/upgrade-pricing.tsx#L125`

### 4. Web Security Headers & Network Hygiene
- ✔ **PASS**  `HTTP Security Headers` (HSTS, CSP, Frame Options)
  - **Details**: `Strict-Transport-Security`, `X-Frame-Options: SAMEORIGIN`, `nosniff`, and Referrer policies configured.
  - **Location**: `apps/web/next.config.mjs#L54`

---

## 7. Remediation Priority Matrix
- 🔴 **CRITICAL (P0)**: Accessibility blockers (unreachable elements, zero contrast), privacy violations (tracking before consent), clickjacking vulnerabilities.
- 🟡 **WARNING (P1)**: Missing ARIA states, unlabelled auxiliary icons, missing refund details on paid tiers.
- 🟢 **INFO / PASS (P2)**: Best-practice advisories and verified passing benchmarks.
- **Do not flag non-applicable checks as failures**: If a site is a free non-commercial tool without user accounts, do not fail it for lacking an e-commerce refund policy.
