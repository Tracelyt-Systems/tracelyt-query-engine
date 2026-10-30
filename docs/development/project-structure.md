# Project Structure

This document outlines the directory structure, package layout, and design conventions of the `tracelyt-query-engine` repository.

---

## 1. Directory Tree Overview

```text
tracelyt-query-engine/
├── .github/                       # GitHub automation, issues, and CI/CD workflows
│   ├── ISSUE_TEMPLATE/            # Structured issue templates (bug reports, feature requests)
│   ├── workflows/                 # Pinned GitHub Actions workflows (CI, docs, dependency review)
│   ├── CODEOWNERS                 # Maintainer code ownership definitions
│   ├── PULL_REQUEST_TEMPLATE.md   # Standard checklist for incoming pull requests
│   └── dependabot.yml             # Automated dependency update configuration
│
├── assets/                        # Static assets (official Tracelyt logo)
│   └── tracelyt-logo.png
│
├── contracts/                     # Boundary declarations & external schema links (tracelyt-specs)
│   └── README.md
│
├── docs/                          # Comprehensive architectural and operational documentation
│   ├── README.md                  # Documentation index & reading paths
│   ├── architecture/              # Core architecture, boundaries, lifecycle, and storage strategy
│   │   ├── overview.md
│   │   ├── system-boundaries.md
│   │   ├── technology-strategy.md
│   │   ├── storage-strategy.md
│   │   ├── query-lifecycle.md
│   │   ├── scalability.md
│   │   ├── failure-model.md
│   │   ├── deployment-models.md
│   │   ├── language-boundaries.md
│   │   └── diagrams/
│   │       └── README.md
│   ├── decisions/                 # Architecture Decision Records (ADRs)
│   │   ├── README.md
│   │   ├── adr-template.md
│   │   └── 0001-adopt-java21-spring-boot-foundation.md
│   ├── development/               # Developer guides, testing strategies, coding standards
│   │   ├── local-setup.md
│   │   ├── project-structure.md
│   │   ├── coding-standards.md
│   │   ├── testing-strategy.md
│   │   ├── dependency-management.md
│   │   └── contribution-workflow.md
│   ├── security/                  # Threat model, data privacy, and secure development
│   │   ├── README.md
│   │   ├── threat-model.md
│   │   ├── secure-development.md
│   │   ├── data-privacy.md
│   │   └── supply-chain.md
│   ├── operations/                # Production operations, observability, limits, capacity
│   │   ├── configuration.md
│   │   ├── observability.md
│   │   ├── resource-limits.md
│   │   ├── capacity-planning.md
│   │   ├── disaster-recovery.md
│   │   └── deployment-readiness.md
│   ├── standards/                 # Contract governance, compatibility, error formats
│   │   ├── contract-governance.md
│   │   ├── compatibility.md
│   │   ├── error-handling.md
│   │   └── performance-testing.md
│   └── roadmap/                   # Evolutionary roadmap and capability milestones
│       ├── README.md
│       └── architecture-evolution.md
│
├── src/                           # Java source and test code
│   ├── main/
│   │   ├── java/
│   │   │   └── io/tracelyt/queryengine/
│   │   │       └── QueryEngineApplication.java
│   │   └── resources/
│   │       └── application.yml
│   └── test/
│       ├── java/
│       │   └── io/tracelyt/queryengine/
│       │       └── QueryEngineApplicationTest.java
│       └── resources/
│           └── application-test.yml
│
├── tools/                         # Maintenance and verification scripts
│   ├── README.md
│   └── validate_docs.py
│
├── .checkstyle.xml                # Checkstyle rule definitions (120 char limit, import order)
├── .editorconfig                  # Editor indentation and line termination rules
├── .gitattributes                 # Git line ending normalization (LF)
├── .gitignore                     # Build, IDE, and temporary file exclusions
├── .dockerignore                  # Container build context exclusions
├── .java-version                  # Declared Java version (21)
├── .markdownlint-cli2.jsonc       # Markdown style configuration
├── .yamllint                      # YAML syntax and formatting configuration
├── Makefile                       # Developer convenience build targets
├── pom.xml                        # Maven project descriptor & dependency versions
├── mvnw / mvnw.cmd                # Apache Maven Wrapper scripts
├── CHANGELOG.md                   # Keep a Changelog release notes
├── CODE_OF_CONDUCT.md             # Contributor Covenant Code of Conduct
├── CONTRIBUTING.md                # Contribution guidelines and pull request flow
├── GOVERNANCE.md                  # Project governance, decision making, maintainer roles
├── LICENSE                        # Apache License 2.0 full text
├── MAINTAINERS.md                 # Current maintainer roster
├── NOTICE                         # Apache 2.0 attribution notice
├── README.md                      # Primary repository landing page
├── SECURITY.md                    # Vulnerability reporting and security policy
└── SUPPORT.md                     # Community channels and support guidelines
```

---

## 2. Java Package Layout

The root Java package is `io.tracelyt.queryengine`.

Future packages should adhere to explicit layer boundaries:

| Package | Future Responsibility | Allowed Dependencies | Prohibited Content |
|---|---|---|---|
| `io.tracelyt.queryengine.bootstrap` | Application main class, Spring Boot configuration, health probes | Spring Core, Actuator | Query logic, database drivers |
| `io.tracelyt.queryengine.admission` *(Planned)* | Rate limiting, tenant concurrency checking, timeout assignment | In-memory limits | Direct storage access |
| `io.tracelyt.queryengine.planner` *(Planned)* | Logical query AST validation, predicate pushdown planning | In-memory AST models | Execution threads, I/O |
| `io.tracelyt.queryengine.storage` *(Planned)* | Interface contracts for analytical storage adapters | Storage SPI contracts | Direct hardcoded SQL/PromQL drivers |
| `io.tracelyt.queryengine.model` *(Planned)* | Query request/response DTOs adhering to `tracelyt-specs` | Language primitives, validation | Database entities |
