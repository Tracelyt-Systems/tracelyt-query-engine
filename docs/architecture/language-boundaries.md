# Multi-Language Architecture and Monorepo Policy

This document defines the policy governing multi-language expansion, runtime boundaries, and inter-service communication in `tracelyt-query-engine`.

---

## 1. Multi-Language Monorepo Policy

To prevent architectural fragmentation and unnecessary build complexity:
- **Do not introduce multiple languages merely for appearance.**
- Every runtime must solve a verified technical requirement that cannot be satisfied cleanly by the primary application language (Java 21).
- The repository will remain a single-language Java foundation during the pre-1.0 setup stage.

---

## 2. Language Roles & Boundaries

### 2.1 Java (Active Foundation)
- **Assigned Role**: Query API orchestration, tenant admission control, configuration distribution, query planning, and baseline storage adapter execution.
- **Rules**: Must adhere strictly to Checkstyle rules, clean package hierarchies (`io.tracelyt.queryengine`), and zero-leakage error handling.

### 2.2 Go (Approved Candidate for Future Workers)
- **Prospective Role**: Horizontally scaled, stateless query execution workers if lightweight container footprint and instant startup become critical.
- **Boundary Rule**: If introduced, Go workers must run as independent processes communicating with Java coordinators via stable gRPC or HTTP interfaces defined in `tracelyt-specs`. Go and Java code will never share in-memory state or foreign-function bindings.

### 2.3 Rust / C++ (Candidate for Native Acceleration)
- **Prospective Role**: Low-level SIMD-accelerated filtering or native decompression libraries.
- **Adoption Gates**: Requires profiling proof that JVM execution is bottlenecked by CPU or memory allocation, followed by formal maintainer consensus via an accepted ADR.

### 2.4 Python (Excluded from Core Path)
- **Policy**: Prohibited from the latency-sensitive query execution path. Python may be utilized by separate analytical tools or AI services (`tracelyt-ai-investigator`), interacting with the query engine strictly over authenticated network APIs.

---

## 3. Shared Cross-Language Rules

1. **Contract-First Communication**: All inter-service communication across language boundaries must use versioned contracts governed in `tracelyt-specs`.
2. **Independent CI Pipelines**: Continuous integration workflows for secondary languages will be added only when the corresponding code is formally merged.
3. **No Direct FFI Complexity Without Proof**: Prefer network boundaries (gRPC/HTTP) over in-process JNI/FFI bindings unless sub-millisecond serialization benchmarks mandate in-process execution.
