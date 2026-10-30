# Query Execution Lifecycle

This document describes the conceptual 10-step lifecycle of an observability telemetry query within the Tracelyt platform.

> [!NOTE]
> **Conceptual Architecture**: This document outlines the planned lifecycle flow. No query parsing, authorization proxies, or database query executors are active in this foundation release.

---

## The 10-Step Conceptual Query Lifecycle

```text
1. Submission ---> 2. Tenant Context ---> 3. Policy & Auth ---> 4. Complexity & Limits
      |                                                                 |
      v                                                                 v
5. Translation ---> 6. Source Selection ---> 7. Execution & Deadline ---> 8. Normalization
      |                                                                 |
      v                                                                 v
9. Observability ---> 10. Privacy Redaction & Response
```

### Step 1: Query Submission
- An authenticated client (Tracelyt UI, API client, or alerting engine) submits a query request specifying the telemetry signal, time range, filter criteria, and optional aggregation operators.

### Step 2: Tenant & Project Context Resolution
- The query engine extracts and verifies cryptographic tenant and project metadata from the authenticated session context (propagated by `tracelyt-control-plane`).
- Client-supplied tenant overrides are strictly rejected.

### Step 3: Request Validation & Policy Verification
- Syntactic validation ensures required fields (`start`, `end`) are present and conform to UTC ISO-8601 formatting.
- Verifies that the tenant has active query entitlements and has not exceeded their concurrent query quota.

### Step 4: Complexity Analysis & Admission Control
- The query planner estimates query cost based on the requested time window width, filter cardinality, and aggregation complexity.
- Queries requesting unbounded time ranges (e.g., > 30 days without partition filters) are rejected immediately at the admission boundary before hitting storage.

### Step 5: Query Plan Translation
- The query is translated into an internal abstract syntax tree (AST), decoupling the incoming user query from backend-specific dialects.

### Step 6: Data Source & Adapter Selection
- The query engine routes the query to the appropriate storage adapter (e.g., ClickHouse for hot/warm logs and spans, cold storage for archived historical traces).

### Step 7: Bounded Execution with Deadline Propagation
- The storage adapter executes the query against the backend database.
- Execution is strictly bounded by deadlines (e.g., maximum 30 seconds). If the client disconnects or the deadline expires, cancellation signals are propagated immediately to the database engine to terminate running queries.

### Step 8: Result Normalization & Pagination
- Raw database result sets are normalized into standard response structures defined in [`tracelyt-specs`](https://github.com/Tracelyt-Systems/tracelyt-specs).
- Large result sets are partitioned into cursor-based pages with hard row and byte caps.

### Step 9: Operational Telemetry & Cost Accounting
- The query engine records execution duration, scanned byte volume, rows returned, and cache hit/miss status in internal Prometheus metrics.
- Scanned volume is attributed to the tenant's resource consumption metrics.

### Step 10: Privacy Redaction & Safe Response Delivery
- In-flight redaction rules verify that sensitive attributes are not exposed in query results.
- The formatted response is streamed safely to the client over HTTP/REST or gRPC.
