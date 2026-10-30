# Security Architecture & Policies

This directory outlines the security posture, threat modeling, privacy controls, and supply-chain governance for `tracelyt-query-engine`.

---

## Security Documentation Overview

| Document | Purpose |
|---|---|
| [Threat Model](threat-model.md) | STRIDE-aligned threat analysis, trust boundaries, attack scenarios, and mitigations. |
| [Secure Development](secure-development.md) | Defensive coding standards, input validation, and vulnerability triage processes. |
| [Data Privacy & Minimization](data-privacy.md) | PII redaction, sensitive attribute handling, query audit logging, and data masking. |
| [Supply Chain Security](supply-chain.md) | Dependency pinning, GitHub Actions SHA immutability, and container provenance. |

---

## Reporting Vulnerabilities

If you discover a security vulnerability in this repository, please follow the coordinated disclosure policy in [`SECURITY.md`](../../SECURITY.md). **Do not open public GitHub issues for undisclosed security vulnerabilities.**
