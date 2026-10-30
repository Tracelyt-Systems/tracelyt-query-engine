# Storage Strategy and Backend Evaluation

This document outlines the storage-agnostic architecture of the Tracelyt Query Engine and evaluates candidate storage backends for telemetry data.

> [!IMPORTANT]
> **Storage-Agnostic Design**: The Tracelyt Query Engine is designed to be storage-agnostic. No database drivers, ORMs, or connection pools are included in this foundation setup. Storage backends are evaluated as candidates rather than mandatory platform commitments.

---

## 1. Storage Backend Evaluation Matrix

| Storage Category | Candidate Technology | Telemetry Domain | Query Characteristics | Operational Complexity | Licensing | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Columnar Analytical Store** | [ClickHouse](https://clickhouse.com/) | Traces, Logs, Aggregated Metrics | Ultra-fast aggregation across billions of rows; vector execution. | Moderate-to-High (cluster sharding, merge trees, ZooKeeper/Keeper). | Apache 2.0 | Primary Candidate |
| **Time-Series Metric Store** | [VictoriaMetrics](https://victoriametrics.com/) / Prometheus | Time-Series Metrics | High-efficiency PromQL execution; high compression for floats. | Low-to-Moderate (simple single-node or clustered architecture). | Apache 2.0 | Candidate |
| **Cold Object Storage** | S3 / MinIO / GCS | Historical Traces & Archived Logs | Cost-effective long-term retention; higher latency for analytical scans. | Low (managed cloud object storage) or Moderate (self-hosted MinIO). | Apache 2.0 / Commercial | Candidate |
| **Search-Oriented Store** | OpenSearch | Application Logs | Full-text inverted index searches; keyword tokenization. | High (JVM heap sizing, segment merging, index management). | Apache 2.0 | Candidate |

---

## 2. Ingestion vs. Query Workload Trade-offs

Observability telemetry presents opposing workload demands on storage systems:
- **Write Path**: Relies on continuous high-throughput append-only batch writes. Row-by-row updates or point mutations are strictly avoided.
- **Read Path**: Requires partition pruning by timestamp, filtering by tenant ID, and scanning compressed columnar blocks for aggregations.

### Why ClickHouse is the Primary Telemetry Candidate:
ClickHouse excels at scanning billions of compressed structured records without the massive memory overhead of full-text inverted indexes. Combining ClickHouse for hot/warm telemetry with object storage for cold historical archives provides an optimal balance between query latency and infrastructure cost.

---

## 3. Pluggable Storage Adapter Boundary (Planned)

When storage integrations are implemented, the query engine will access databases exclusively through a clean, decoupled adapter boundary:

```text
[ Query Execution Engine ]
           |
           v
[ Storage Adapter Interface ]
     |              |             |
     v              v             v
[ ClickHouse ] [ TimeSeries ] [ Object Store ]
```

### Future Adapter Interface Responsibilities:
1. **Query Translation**: Translating internal abstract query expressions into backend-native queries (e.g., SQL for ClickHouse, PromQL for TSDB).
2. **Predicate Pushdown**: Passing time bounds (`start_time`, `end_time`) and tenant filters directly to the storage engine to maximize partition pruning.
3. **Streamed Serialization**: Streaming result sets directly to consumers without buffering massive query payloads in application memory.
4. **Health & Latency Telemetry**: Emitting backend query execution duration, scanned byte volume, and error rates to the query engine's observability metrics.
