# System Boundaries and Component Ownership

This document defines the strict functional boundaries separating `tracelyt-query-engine` from other components across the Tracelyt platform.

---

## 1. Platform Component Responsibility Matrix

| Component Repository | Primary Architectural Role | What Belongs Here | What Explicitly Does NOT Belong Here |
| :--- | :--- | :--- | :--- |
| **`tracelyt-query-engine`** *(This Repository)* | Data Plane Read Path & Query Orchestration | Query parsing, validation, time-range bounding, partition pruning, storage adapter execution, result serialization, query observability. | User identity management, billing, edge OTLP network termination, telemetry stream ingestion, alert state tracking. |
| **`tracelyt-control-plane`** | Central Platform Administration | Tenant lifecycle, project provisioning, RBAC, API key issuance, query quota distribution. | Analytical query execution, full-text log scanning, raw trace storage. |
| **`tracelyt-ingestion`** | Edge Protocol Gateway | OTLP network listeners (gRPC/HTTP), edge authentication, rapid rate limiting, early payload framing checks. | Query planning, database read queries, dashboard APIs. |
| **`tracelyt-telemetry-pipeline`** | In-Flight Data Processing | Telemetry sanitization, attribute normalization, privacy redaction, drop filtering, micro-batch write aggregation. | Read-path analytical query planning, dashboard rendering. |
| **`tracelyt-alerting`** | Incident & Rule Engine | Alert threshold definitions, incident lifecycle tracking, state transition evaluation. | Direct storage cluster indexing, query engine internal scheduling. |
| **`tracelyt-notifications`** | Alert Dispatch Integration | Outbound webhooks, Slack/PagerDuty delivery, retry policies. | Data retrieval, telemetry queries, trace parsing. |
| **`tracelyt-ai-investigator`** | Diagnostic Intelligence | Automated root-cause correlation, telemetry summarization, diagnostic LLM workflows. | Unbounded direct database access, raw SQL execution. |
| **`tracelyt-specs`** | Shared Contract Authority | Shared OpenAPI specifications, JSON schemas, Protobuf definitions, pagination standards. | Runtime applications, database drivers, executable code. |
| **`tracelyt-deploy`** | Infrastructure Automation | Docker Compose stacks, Kubernetes Helm charts, cloud provisioning. | Service-internal application configuration. |

---

## 2. Preventing Functional Coupling

To ensure maintainability and prevent architectural erosion, we enforce the following rules:

### 2.1 Query Engine vs. Control Plane
- The query engine relies on authenticated tenant and project metadata verified by `tracelyt-control-plane`.
- **Rule**: The query engine never creates users, issues API tokens, or modifies tenant organizations. It reads tenant quota policies and enforces them on queries.

### 2.2 Query Engine vs. Ingestion & Pipeline
- `tracelyt-ingestion` and `tracelyt-telemetry-pipeline` write telemetry into storage backends.
- `tracelyt-query-engine` reads telemetry from storage backends.
- **Rule**: The query engine does not receive raw OTLP network traffic, does not parse incoming telemetry streams, and does not perform data write-batching.

### 2.3 Query Engine vs. AI Investigator
- `tracelyt-ai-investigator` consumes targeted, bounded query results through the standard query interface.
- **Rule**: The query engine never embeds LLM SDKs, prompt engineering libraries, or vector databases. It remains a high-performance, deterministic telemetry retrieval service.
