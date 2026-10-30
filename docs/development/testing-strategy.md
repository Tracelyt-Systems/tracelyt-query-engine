# Testing Strategy

This document outlines the testing pyramid, verification layers, and non-blocking testing principles for the `tracelyt-query-engine` repository.

---

## 1. Testing Philosophy

The query engine is a critical path for data retrieval across the Tracelyt observability platform. Its testing strategy balances rigorous verification with fast, deterministic local execution:

1. **Deterministic & Fast:** Baseline unit tests must execute in under 10 seconds locally without requiring network, containers, or background daemon processes.
2. **Zero External Dependencies for Smoke Tests:** Unit tests must never depend on live databases (ClickHouse, PostgreSQL), Kafka brokers, or cloud object stores.
3. **No Mock Telemetry Presented as Real:** We do not generate synthetic query results or assert on fake telemetry data. Tests assert on actual component behavior, configuration loading, and contract adherence.
4. **Adherence to Shared Contracts:** Contract tests must validate serialization/deserialization against models defined in `tracelyt-specs`.

---

## 2. Testing Layers

| Layer | Purpose | Scope | Tooling | Execution Environment |
|---|---|---|---|---|
| **Unit Tests** | Verify isolated algorithms, AST validation, admission math | Classes, pure functions, state-free logic | JUnit 5, AssertJ | In-process, `<forkCount>0</forkCount>`, fast |
| **Context Smoke Tests** | Verify Spring application context loading and bean wiring | `QueryEngineApplicationTest` | `@SpringBootTest` | Fast, in-process, tests port 8083 binding |
| **Contract Tests** *(Planned)* | Verify JSON/Protobuf schemas match `tracelyt-specs` | DTO serialization, error envelope mapping | Jackson, JSONAssert | In-process, validates schema compatibility |
| **Adapter Integration Tests** *(Planned)* | Verify storage queries against real test engines | Storage SPI implementations | Testcontainers (ephemeral) | Isolated CI runners with Docker capability |
| **Performance & Load Tests** *(Planned)* | Measure concurrency saturation, memory consumption | Scalability and queue depth | Dedicated load harness | Isolated performance benchmarking cluster |

---

## 3. Current Implementation Status

In this foundation phase:
- **Implemented:** [`QueryEngineApplicationTest`](../../src/test/java/io/tracelyt/queryengine/QueryEngineApplicationTest.java) verifies that the Spring Boot 3.4 context loads cleanly and binds required actuator endpoints.
- **Intentionally Omitted:** No database tests, no mock query evaluations, and no artificial assertions (`assertTrue(true)`).

---

## 4. Running Tests

```bash
# Run tests via Maven Wrapper
./mvnw -B -ntp test

# Windows equivalent
mvnw.cmd -B -ntp test
```
