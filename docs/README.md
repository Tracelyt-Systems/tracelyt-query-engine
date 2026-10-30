# Tracelyt Query Engine Documentation

Welcome to the documentation repository for the **Tracelyt Query Engine** subsystem.

---

## Documentation Navigation

### 1. Architecture & Design
- [Architecture Overview](architecture/overview.md): Architectural role, data plane placement, and high-level Mermaid flow.
- [System Boundaries](architecture/system-boundaries.md): Component responsibilities across Tracelyt platform services.
- [Technology Strategy](architecture/technology-strategy.md): Evaluation of languages, runtimes, and decision criteria.
- [Storage Strategy](architecture/storage-strategy.md): Storage-agnostic architecture, candidate backends, and adapter design.
- [Query Lifecycle](architecture/query-lifecycle.md): Conceptual 10-step lifecycle of a telemetry query.
- [Scalability & Concurrency](architecture/scalability.md): Query admission control, partition pruning, and high-cardinality safeguards.
- [Failure Model](architecture/failure-model.md): Failure modes, timeout handling, and degradation scenarios.
- [Deployment Models](architecture/deployment-models.md): Standalone vs. distributed query worker topologies.
- [Language Boundaries](architecture/language-boundaries.md): Multi-language monorepo policy and polyglot adoption gates.
- [Architecture Diagrams](architecture/diagrams/README.md): Index of Mermaid system and sequence diagrams.

### 2. Architecture Decision Records (ADRs)
- [ADR Index](decisions/README.md): Log of significant architectural decisions and outcomes.
- [ADR Template](decisions/adr-template.md): Standard lightweight format for proposing new ADRs.

### 3. Development Guides
- [Local Setup](development/local-setup.md): Prerequisites, build commands, and workstation configuration.
- [Project Structure](development/project-structure.md): Repository directory structure and package organization.
- [Coding Standards](development/coding-standards.md): Checkstyle rules, Java 21 conventions, and static analysis.
- [Testing Strategy](development/testing-strategy.md): Unit testing philosophy and memory-safe Surefire execution.
- [Dependency Management](development/dependency-management.md): Minimal dependency policy and vulnerability tracking.
- [Contribution Workflow](development/contribution-workflow.md): Branching strategy, issue templates, and PR guidelines.

### 4. Security & Privacy
- [Security Overview](security/README.md): High-level security posture and core tenets.
- [Threat Model](security/threat-model.md): Threat actors, attack scenarios, assets, and mitigation matrix.
- [Secure Development](security/secure-development.md): SDLC practices, input validation, and secret hygiene.
- [Data Privacy](security/data-privacy.md): Telemetry data minimization, PII handling, and attribute redaction.
- [Supply Chain Security](security/supply-chain.md): Action commit SHA pinning, read-only CI, and artifact integrity.

### 5. Operations & Production Readiness
- [Configuration Strategy](operations/configuration.md): Safe defaults, environment variables, and secret injection.
- [Observability Strategy](operations/observability.md): Self-monitoring metrics, health probes, and cardinality protection.
- [Resource Limits](operations/resource-limits.md): Query deadlines, memory budgets, and tenant quota controls.
- [Capacity Planning](operations/capacity-planning.md): Sizing dimensions, workload profiles, and benchmark gates.
- [Disaster Recovery](operations/disaster-recovery.md): Storage partition recovery and node failure handling.
- [Deployment Readiness](operations/deployment-readiness.md): Container security, liveness/readiness probes, and shutdown lifecycle.

### 6. Standards & Specifications
- [Contract Governance](standards/contract-governance.md): Relationship with `tracelyt-specs` and change workflows.
- [Compatibility Policy](standards/compatibility.md): Semantic versioning and breaking change definitions.
- [Error Handling](standards/error-handling.md): RFC 9457 Problem Details error conventions.
- [Performance Testing](standards/performance-testing.md): Sustained load testing and benchmark methodology.

### 7. Roadmap & Evolution
- [Roadmap Overview](roadmap/README.md): Phased development milestones from foundation to scale.
- [Architecture Evolution](roadmap/architecture-evolution.md): Detailed 5-stage evolutionary path.
