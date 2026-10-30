# Architectural Roadmap & Milestones

This directory documents the planned evolutionary path and future milestone stages for `tracelyt-query-engine`.

---

## Roadmap Documentation

| Document | Purpose |
|---|---|
| [Architecture Evolution](architecture-evolution.md) | Structured 5-stage progression from initial foundation to production analytical query engine. |

---

## Current Status: Stage A (Foundation)

The repository is currently at **Stage A (Foundation)**:
- Engineering foundation, build automation, Checkstyle, and CI workflows established.
- Comprehensive architectural, security, storage, and scalability documentation defined.
- Minimal Java 21 LTS + Spring Boot 3.4.3 application bootstrap with verified context startup.
- **Strictly No Query Execution:** No PromQL/SQL parsing, no database drivers, no mock endpoints, and no distributed execution workers are implemented.
