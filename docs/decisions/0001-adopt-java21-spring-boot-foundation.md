# ADR-0001: Adopt Java 21 LTS and Spring Boot 3.4 Foundation

- **Status:** Accepted
- **Date:** 2026-10-26
- **Deciders:** Tracelyt Architecture Team, Subsystem Maintainers

## Context

The Tracelyt Observability Platform requires a query engine subsystem (`tracelyt-query-engine`) responsible for coordinating query lifecycle, validating user tenant scope, executing query admission control, dispatching bounded execution tasks to underlying analytical storage engines, and normalizing query responses for dashboards and alerting pipelines.

We need a foundational runtime and framework for this service that provides:
1. Long-term support (LTS) stability, active security updates, and predictable release cadences.
2. High-performance asynchronous execution, structured concurrency, and virtual threads (Project Loom) to handle high-concurrency query admission without thread pool exhaustion.
3. Compatibility with the existing Java-based Tracelyt services (`tracelyt-control-plane`, `tracelyt-ingestion`, `tracelyt-telemetry-pipeline`), enabling shared engineering standards, common build tooling, and code reuse.
4. Minimal operational complexity during the initial foundation phase, without premature multi-language sprawl.

## Decision

We adopt **Java 21 LTS** with **Spring Boot 3.4.x** (managed via Apache Maven) as the initial bootstrap and query orchestration foundation for `tracelyt-query-engine`.

Key choices:
- **Language / Runtime:** Java 21 LTS (Oracle OpenJDK / Microsoft Build of OpenJDK / Eclipse Temurin).
- **Framework:** Spring Boot 3.4.x with minimal dependencies (`spring-boot-starter`, `spring-boot-starter-actuator` for health endpoints, `spring-boot-starter-test`).
- **Build System:** Apache Maven with Maven Wrapper (`mvnw` / `mvnw.cmd`) for reproducible developer and CI builds.
- **Strict Implementation Boundary:** The initial bootstrap contains only application startup context verification. No database drivers, Kafka brokers, Redis caches, or query evaluation engines are introduced at this stage.

## Alternatives Considered

1. **Go (Golang):**
   - *Pros:* Fast compilation, small container footprint, strong built-in concurrency primitives.
   - *Cons:* Diverges from the team's shared Java ecosystem for contract and configuration handling. Does not provide an immediate architectural advantage during the initial query orchestration setup.
   - *Outcome:* Documented as an approved candidate for future high-concurrency worker nodes (see [Language Boundaries](../architecture/language-boundaries.md)), but deferred for the initial coordinator foundation.

2. **Rust / C++:**
   - *Pros:* Maximum CPU and memory efficiency, fine-grained SIMD and vectorization capabilities.
   - *Cons:* High build complexity, steep learning curve, extensive CI maintenance, and lack of pre-existing team operational tooling.
   - *Outcome:* Deferred until specific analytical vectorized filtering bottlenecks are measured with reproducible benchmarks.

3. **Node.js / TypeScript:**
   - *Pros:* Rapid HTTP prototyping, shared frontend types.
   - *Cons:* Single-threaded event loop creates challenges for CPU-heavy telemetry aggregation and large dataset parsing; poor fit for platform core infrastructure.
   - *Outcome:* Rejected for query engine core.

## Consequences

### Positive
- Unified build toolchain, style checking (Checkstyle 10.21.4), and CI/CD pipelines across Tracelyt platform repositories.
- Virtual threads (Java 21 Loom) provide lightweight, scalable I/O wait handling for downstream storage queries without complex reactive programming models.
- Rich enterprise observability tooling (Micrometer, Actuator, OpenTelemetry Java SDK compatibility).

### Negative / Trade-offs
- Higher JVM memory footprint at idle compared to a static Go or Rust binary.
- JVM startup time requires warmup for peak JIT optimization (mitigated in future stages via CRaC or GraalVM Native Image if operational requirements demand it).

## Security Implications
- Leverages mature Java security models, automated Dependabot alerts, and GitHub dependency review.
- Strict dependency discipline ensures zero unneeded transitives or vulnerable drivers are added to `pom.xml`.

## Operational Implications
- Production deployments require a standard headless JRE 21 container image (e.g., Eclipse Temurin Alpine/Debian).
- Standard JMX and HTTP Actuator health/readiness endpoints (`/actuator/health`) integrate natively with Kubernetes and Docker Compose health checks.

## Revisit Conditions
- If profiling demonstrates that query planning or analytical filtering requires native SIMD speed unreachable via Java vector APIs, a Rust native library or specialized worker service will be evaluated.
- If edge deployment requirements demand a sub-20MB static binary, a Go query proxy or GraalVM compilation path will be explored.
