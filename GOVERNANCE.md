# Project Governance

This document establishes the open-source governance model, decision-making procedures, and maintainer responsibilities for `tracelyt-query-engine`.

---

## 1. Governance Principles

The Tracelyt project is committed to:
- **Open Collaboration**: All design proposals, issue discussions, and architectural reviews take place publicly on GitHub.
- **Decision Transparency**: Significant architectural decisions are documented as Architecture Decision Records (ADRs) under `docs/decisions/`.
- **Meritocracy and Consensus**: Technical directions are decided by technical consensus among active maintainers and contributors.

---

## 2. Roles and Responsibilities

### Contributors
Anyone who submits issues, pull requests, documentation updates, or participates in discussions. Contributors must follow the [Code of Conduct](CODE_OF_CONDUCT.md).

### Reviewers
Experienced contributors who review pull requests for code quality, adherence to [Coding Standards](docs/development/coding-standards.md), and security practices.

### Maintainers
Designated project leads responsible for the repository health, architectural alignment, pull request merges, security vulnerability handling, and release tags. Current maintainers are recorded in [MAINTAINERS.md](MAINTAINERS.md).

---

## 3. Decision-Making Process

1. **Routine Changes**: Bug fixes, documentation updates, and routine dependency bumps require approval from at least one maintainer.
2. **Architectural Changes**: Proposing new query parsers, storage adapters, or multi-language services requires:
   - Opening an RFC issue.
   - Authoring a draft Architecture Decision Record (ADR).
   - Review and consensus from maintainers listed in [.github/CODEOWNERS](.github/CODEOWNERS).
