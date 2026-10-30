# Contract Governance & Schema Evolution

This document defines the schema governance process, protocol selection criteria, and request/response conventions for `tracelyt-query-engine`.

> **Canonical Authority:** The [`tracelyt-specs`](https://github.com/Tracelyt-Systems/tracelyt-specs) repository is the sole canonical source of truth for approved platform contracts. No shared API models, gRPC schemas, or error envelopes may be independently invented or finalized in this repository without prior approval in `tracelyt-specs`.

---

## 1. Protocol Selection Criteria

Future query engine APIs will evaluate transport protocols based on explicit criteria:

| Criterion | HTTP / JSON (REST) | gRPC / Protocol Buffers | WebSocket / SSE |
|---|---|---|---|
| **Browser / Web UI Compatibility** | Native; zero proxies required. | Requires gRPC-Web proxy (Envoy). | Native support for streaming live tails. |
| **Internal Service Interoperability** | Universal, easy debugging via cURL. | High throughput, compact binary serialization. | Overkill for simple request-response queries. |
| **Streaming Large Results** | Chunked transfer encoding. | Native bidirectional streaming. | High connection state overhead. |
| **Client Code Generation** | OpenAPI / Swagger tooling. | Protoc compiler generates idiomatic stubs. | Custom protocol wrappers needed. |
| **Self-Hosted Simplicity** | Very high; standard ingress controllers. | Moderate; requires HTTP/2 ingress support. | Moderate; requires sticky reverse proxy config. |

**Baseline Recommendation:**
- **External Query API (Dashboard / Alerting / CLI):** HTTP/1.1 and HTTP/2 with JSON payloads adhering to OpenAPI 3.1 specifications.
- **Internal Worker Execution (Coordinator to Worker / Storage):** gRPC with Protobuf for high-volume partition transfer.

---

## 2. API Conventions (Proposed Design)

When future contracts are drafted for review in `tracelyt-specs`, they must adhere to:

### 2.1 Timestamp Semantics
- Timestamps must always use UTC and ISO-8601 representation (e.g., `2026-10-26T15:30:00.000Z`) or explicit Unix epoch nanoseconds (`timestamp_ns`).
- Relative duration strings must use explicit units: `15m` (minutes), `2h` (hours), `7d` (days). Never assume unspecified integer seconds.

### 2.2 Time-Range Queries
Time-range queries must define explicit bounds:
```json
{
  "start": "2026-10-26T14:00:00Z",
  "end": "2026-10-26T15:00:00Z",
  "step": "15s"
}
```

### 2.3 Result Pagination & Limits
- Unbounded queries are prohibited. Every query must specify an explicit `limit` (default: 1,000, max: 100,000).
- Pagination must use opaque cursor tokens (`next_cursor`), never offset-based pagination (`OFFSET 50000`) which degrades analytical storage performance.

### 2.4 Correlation & Tenant Context
- `X-Tracelyt-Tenant-ID`: Cryptographically validated tenant scope passed by the API gateway or control plane.
- `X-Tracelyt-Project-ID`: Targeted project identifier.
- `X-Request-ID` / `traceparent`: Correlation identifiers propagated across all downstream storage queries and operational log lines.
