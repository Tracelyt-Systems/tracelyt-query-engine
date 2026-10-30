# Failure Model and Resilience Strategy

This document details the failure modes of the Tracelyt Query Engine, analyzing degradation scenarios and defining the required behavioral responses.

> [!WARNING]
> **Retries are Not Universally Safe**: Read-only queries can be resource-intensive. Indiscriminate client retries during database slowdowns amplify cluster overload (retry storms), transforming transient latency spikes into full outages. Retries must be strictly bounded by budgets and exponential backoff with jitter.

---

## 1. Failure Categories & Expected Behaviors

| Failure Scenario | Root Cause | Impact | Planned System Response | Owning Component |
| :--- | :--- | :--- | :--- | :--- |
| **Storage Backend Unavailable** | ClickHouse or TSDB cluster down or partitioned. | Queries cannot retrieve data. | Fail fast with `503 Service Unavailable`; do not queue queries indefinitely; return retry-after hints. | Storage Adapter |
| **Storage Backend Overloaded** | Heavy compaction or write spikes causing slow reads. | Query latency exceeds SLOs. | Enforce query deadlines; abort queries exceeding timeouts; emit backpressure signals. | Query Execution Engine |
| **Invalid or Malformed Query** | Syntax errors or unknown metric/attribute keys. | Query cannot be parsed. | Return `400 Bad Request` with structured RFC 9457 error details; no backend query executed. | Query Validator / Planner |
| **Query Timeout Exceeded** | Query time range too wide or scan volume too large. | Resource lockup. | Terminate query; emit cancellation signal to database; return `504 Gateway Timeout`. | Execution Coordinator |
| **Client Abrupt Disconnect** | User closes browser tab or navigates away. | Running queries waste backend CPU. | Detect TCP disconnect immediately; propagate cancellation to active storage sessions. | Ingress Transport Layer |
| **Memory Pressure / Allocation Spike** | Deep aggregations ballooning JVM heap. | Risk of JVM crash (OOM). | Admission controller tracks active query memory; rejects new heavy queries with `429 Too Many Requests`. | Admission Controller |
| **Tenant Quota Exhaustion** | Tenant exceeds concurrent query allocation. | Risk of starving other tenants. | Reject query immediately with `429 Too Many Requests` detailing active concurrency limits. | Tenant Context Verifier |
| **Authorization Service Unavailable** | `tracelyt-control-plane` unreachable. | Cannot verify session tokens. | Fail closed: reject queries with `401 Unauthorized` until auth context is verifiable. | Auth Verifier |
| **Graceful Shutdown (SIGTERM)** | Container scaling or deployment rolling restart. | Active queries interrupted. | Cease accepting new queries; allow active queries a grace window (e.g., 30s) to complete before termination. | Runtime Lifecycle Manager |

---

## 2. Partial Results Policy

In distributed observability systems, queries covering dozens of storage shards or time partitions may experience individual node failures:
- **Default Policy**: By default, queries fail completely if a shard is unreachable to prevent users from making operational decisions on incomplete data without notice.
- **Explicit Partial Results**: If a dashboard explicitly enables a `allow_partial_results: true` parameter, the query engine may return aggregated results accompanied by a standard warning header and metadata indicating which time partitions or shards were omitted.
