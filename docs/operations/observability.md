# Subsystem Observability & Telemetry

This document outlines the self-monitoring strategy, health indicators, performance metrics, and high-cardinality prevention rules for `tracelyt-query-engine`.

> **Status Notice:** This document defines the observability design requirements for the query engine. The initial repository exposes only basic Spring Boot Actuator health endpoints (`/actuator/health`). No production Prometheus exporters, OpenTelemetry SDKs, or synthetic dashboards are implemented in this foundation phase.

---

## 1. The Recursive Telemetry Hazard

Because the query engine operates as a core component of an observability platform, self-monitoring telemetry carries a critical architectural risk: **telemetry recursion**.
- If the query engine emits high-volume telemetry that is ingested back into Tracelyt, a high-volume query spike can saturate the query engine, triggering alerting queries, which generate more telemetry in an unbounded feedback loop.
- **Rule:** The query engine must maintain bounded, low-overhead operational metrics. Telemetry labels must strictly avoid high-cardinality values.

---

## 2. Cardinality Safeguards for Metric Labels

### Strictly Prohibited as Metric Labels:
- **Raw Query Text:** Never use full queries, SQL/PromQL statements, or filter expressions as label values.
- **User / Session IDs:** Never use end-user IDs, IP addresses, or browser session tokens.
- **Arbitrary Tenant Input:** Unvalidated labels, custom dimension keys, or regex search strings.

### Permitted Low-Cardinality Labels:
- `signal_type`: `metrics`, `logs`, `traces`.
- `status`: `success`, `bad_request`, `timeout`, `cancelled`, `rate_limited`, `storage_error`.
- `storage_backend`: `clickhouse`, `tsdb`, `object_store`.
- `tenant_id`: Approved only if tenant count is bounded (< 1,000) or aggregated at organization tier.

---

## 3. Candidate Operational Metrics (Design Specification)

When future query coordination and storage adapters are introduced, the subsystem will emit:

| Metric Name | Type | Description | Permitted Labels |
|---|---|---|---|
| `tracelyt_query_duration_seconds` | Histogram | End-to-end query execution latency as experienced by client. | `signal_type`, `status` |
| `tracelyt_query_active_count` | Gauge | Number of queries currently executing. | `signal_type` |
| `tracelyt_query_queue_depth` | Gauge | Queries waiting in admission queue for execution slots. | `priority` |
| `tracelyt_query_rejections_total` | Counter | Queries rejected before execution due to concurrency or rate limits. | `reason` (`quota`, `queue_full`) |
| `tracelyt_query_timeouts_total` | Counter | Queries terminated due to reaching timeout deadlines. | `signal_type` |
| `tracelyt_query_cancellations_total` | Counter | Queries aborted due to client disconnection. | `signal_type` |
| `tracelyt_query_scanned_bytes` | Distribution | Total bytes scanned across underlying storage per query. | `signal_type` |
| `tracelyt_query_result_rows` | Distribution | Total rows returned in query response payloads. | `signal_type` |
| `tracelyt_storage_call_duration_seconds` | Histogram | Round-trip latency of calls to backend analytical storage nodes. | `storage_backend`, `status` |

---

## 4. Distributed Tracing & Request Correlation

Future query requests will accept standard W3C Trace Context headers (`traceparent`, `tracestate`):
- The coordinator will extract the parent span, start an internal query span, and propagate trace context to storage queries where supported.
- Spans will record query stage timings: `admission`, `planning`, `storage_dispatch`, `serialization`.
- PII and raw query parameters will be stripped from span attributes before dispatch.

---

## 5. Health Probes & Readiness

In containerized environments (Kubernetes, Docker), the service provides:
- **Liveness Probe (`/actuator/health/liveness`):** Indicates whether the JVM process is alive and responsive.
- **Readiness Probe (`/actuator/health/readiness`):** Indicates whether the node has completed bootstrap and is ready to accept queries.
