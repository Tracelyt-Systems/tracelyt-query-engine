# Technology Strategy and Evaluation

This document details the architectural evaluation of programming languages, frameworks, caching runtimes, and storage interfaces for the Tracelyt Query Engine.

---

## 1. Technology Decision Matrix

| Technology | Prospective Role | Architectural Utility | Why Deferred / Not Needed Now | Prerequisites for Adoption | Operational & Security Cost | Decision Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Java 21 LTS** | Primary Service Foundation | Mature enterprise ecosystem, strong ecosystem synergy with Tracelyt services, Virtual Threads (Loom). | **Adopted as Foundation**. | Approved setup foundation. | JVM memory footprint, GC tuning under burst queries. | **Initial (Adopted)** |
| **Spring Boot 3.4.3** | Application Orchestration | Dependency injection, structured configuration, Actuator health endpoints, robust test framework. | **Adopted as Foundation**. | Approved setup foundation. | Startup overhead, framework dependency lifecycle. | **Initial (Adopted)** |
| **Maven Wrapper** | Build Automation | Deterministic, reproducible builds across developer workstations and CI runners. | **Adopted as Foundation**. | Approved setup foundation. | Minimal maintenance. | **Initial (Adopted)** |
| **Checkstyle 10.21.4**| Static Code Analysis | Enforces strict code formatting, naming standards, and clean imports. | **Adopted as Foundation**. | Approved setup foundation. | Build failure on style violations. | **Initial (Adopted)** |
| **Go** | Stateless Query Workers | High concurrency, compact memory footprint, fast startup, simple static binary deployment. | Introducing a second language adds duplicate build systems, security auditing, and maintainer cognitive load. | Measured query worker I/O bottleneck in Java. | Multi-language toolchain maintenance, divided open-source contributor pool. | **Candidate (Deferred)** |
| **Rust / C++** | Native Query Acceleration | Zero-cost abstractions, deterministic memory, SIMD vectorization for in-memory column filters. | High development cost, complex FFI boundaries, unsafe memory risks in C++. | Empirical proof that JVM GC/CPU optimizations cannot meet latency SLOs. | High compilation complexity, FFI boundary overhead, specialized developer skills. | **Candidate (Deferred)** |
| **Python** | Offline Analysis / AI Workflows | Rapid prototyping, data science ecosystem. | Interpreter GIL, high runtime latency overhead, unsuitable for latency-sensitive query paths. | Analytical workflow strictly owned outside the core query engine. | Interpreter overhead, packaging complexity. | **Rejected (Core Path)** |
| **Redis** | Query Result Caching | Low-latency key-value caching for dashboard query results. | Adds distributed state, cache invalidation complexity, and infrastructure dependency prematurely. | High repeated query volume with proven cache hit ratios. | Cache stampede risk, cache invalidation bugs, infrastructure maintenance. | **Candidate (Deferred)** |
| **Apache Kafka** | Query Workload Streaming | Event stream log for distributed query distribution. | Query execution is inherently request-response; message brokers add unnecessary operational overhead for reads. | Large distributed worker cluster requiring job queuing. | Cluster operations, partition rebalancing, broker storage costs. | **Candidate (Deferred)** |
| **ClickHouse** | Columnar Telemetry Backend | Ultra-fast analytical queries over billions of spans and logs. | Premature to bind the repository to a single storage vendor before storage adapter interfaces are defined. | Formal storage strategy approval aligned with ingestion pipeline. | Heavy disk I/O, cluster topology operations, schema migrations. | **Candidate (Deferred)** |

---

## 2. Java 21 LTS Selection Rationale

Java 21 LTS was selected as the initial foundation framework for the following architectural reasons:
1. **Virtual Threads (Project Loom)**: Enables the query engine to handle hundreds of concurrent downstream storage queries using synchronous, readable code without reactive callback hell.
2. **Platform Uniformity**: Aligns with `tracelyt-control-plane` and `tracelyt-telemetry-pipeline`, enabling shared developer expertise and tooling across the Tracelyt organization.
3. **Enterprise Resilience**: Proven garbage collectors (ZGC, G1GC) capable of sub-millisecond pauses when properly tuned.
4. **Comprehensive Quality Ecosystem**: Mature testing (JUnit 5, Mockito, Testcontainers) and robust static analysis tooling (Checkstyle).

---

## 3. Policy for Future Polyglot Expansion

The query engine will remain a single-language Java service until the following conditions are satisfied:
1. **Workload Isolation**: A distinct, stateless query sub-component (e.g., worker pool or SIMD filter) is separated by clean network or IPC boundaries.
2. **Empirical Benchmarks**: Reproducible benchmarks demonstrate that Java 21 cannot meet verified latency or throughput SLOs after all JVM optimizations are exhausted.
3. **Maintainer Consensus**: Project maintainers formally approve the operational, build, and security costs of maintaining a secondary runtime via an accepted ADR.
