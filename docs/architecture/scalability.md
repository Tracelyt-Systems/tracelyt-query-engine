# Scalability, Concurrency, and High-Cardinality Safeguards

This document defines the architectural principles and safeguards designed to ensure the Tracelyt Query Engine scales efficiently without falling victim to high-cardinality bottlenecks or query denial-of-service.

---

## 1. High-Cardinality Challenges in Observability

Observability telemetry frequently captures high-cardinality attributes—such as user IDs, request UUIDs, dynamic container hashes, and arbitrary URLs. When users execute queries grouped by or filtered on unbounded high-cardinality fields:
- Inverted indexes experience severe memory ballooning.
- Database query engines exhaust RAM building in-memory hash tables for `GROUP BY` aggregations.
- Result sets grow to hundreds of megabytes, crashing browser dashboards and saturating network interfaces.

---

## 2. Planned Scalability Safeguards

To maintain stability under high-concurrency workloads, future implementations will enforce six architectural safeguards:

### 2.1 Mandatory Time-Range Boundaries
- Every query must specify an explicit finite time range (`start` and `end`). Unbounded queries (e.g., "all errors forever") are rejected at the admission gate.
- Maximum permitted time windows are scaled dynamically based on query granularity (e.g., maximum 7 days for raw log scans, maximum 90 days for downsampled metrics).

### 2.2 Predicate & Time-Range Pushdown
- Query planners ensure that time ranges and tenant filters are pushed directly into storage partition clauses, enabling ClickHouse and TSDB engines to skip 99% of compressed on-disk data blocks without reading them into memory.

### 2.3 Strict Memory and Row Budgets
- Every query runs under hard caps:
  - **Maximum Rows**: e.g., default 5,000 rows (hard ceiling 50,000).
  - **Maximum Response Bytes**: e.g., hard cap of 10 MB per query response.
  - **Memory Quotas**: Database queries that exceed memory limits are aborted with a standardized `QUERY_MEMORY_EXCEEDED` error rather than allowing host OOM crashes.

### 2.4 Query Admission Control & Tenant Fairness
- The query engine implements an admission controller with per-tenant concurrency limits:
  - e.g., a single tenant may execute at most 10 concurrent heavy queries.
  - Excessive requests are queued briefly or rejected with standard `429 Too Many Requests` (RFC 9457 Problem Details) to protect cluster capacity for other tenants.

### 2.5 Deadline Propagation & Cancellation
- If a user cancels a dashboard query or navigates away, the client closes the HTTP connection.
- The query engine captures connection termination immediately and propagates a cancellation signal (`Context.cancel()` or SQL `KILL QUERY`) to the underlying storage engine, releasing database CPU cores instantly.

---

## 3. Distributed Execution Architecture (Future Roadmap)

For large-scale deployments where a single query engine instance cannot coordinate enterprise query volume:
- **Coordinator-Worker Topology**: A query coordinator receives requests, splits wide time ranges into discrete sub-windows (e.g., splitting a 30-day query into thirty 1-day parallel chunks), and dispatches sub-queries to a pool of stateless workers.
- **Scatter-Gather Execution**: Workers query underlying storage partitions in parallel, stream micro-results back to the coordinator, and the coordinator merges and downsamples final results before returning them to the client.
