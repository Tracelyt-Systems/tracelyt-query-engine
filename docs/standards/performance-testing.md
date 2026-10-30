# Performance & Benchmark Testing Standards

This document outlines the performance testing methodology, benchmarking protocols, and latency profiling standards for `tracelyt-query-engine`.

> **Status Notice:** This document defines testing standards for future implementation phases. No performance benchmarks or synthetic load tests have been executed in this foundation repository.

---

## 1. Benchmarking Principles

Performance testing in analytical query subsystems requires disciplined methodology to prevent misleading results:

1. **Realistic Data Distributions:** Avoid synthetic datasets with uniform timestamps or zero entropy. Real telemetry contains bursty spikes, variable payload sizes, and high label cardinality.
2. **Cold vs. Warm Storage Runs:** Differentiate between warm in-memory cache hits and cold disk I/O scans. Benchmark runs must explicitly report both states.
3. **Statistical Latency Profiling:** Never report simple averages. Benchmarks must record full latency percentiles: P50, P90, P99, and P99.9.
4. **Coordinated Omission Prevention:** Benchmarking load generators must account for server pauses (e.g., GC pauses or queue delays) rather than waiting before issuing subsequent requests.

---

## 2. Test Scenarios & Profiles

Future benchmark suites will evaluate three distinct workload profiles:

### 2.1 Interactive Dashboard Profile
- **Concurrency:** 50 to 500 concurrent dashboard viewers.
- **Query Patterns:** Short time ranges (15m to 2h), pre-aggregated metrics, fast point-in-time trace lookups.
- **Target Metrics:** P95 latency, admission queue wait times, coordinator heap memory stability.

### 2.2 Alert Evaluation Profile
- **Concurrency:** Continuous periodic evaluation (e.g., 200 rule queries every 30 seconds).
- **Query Patterns:** Sliding 5-minute aggregation windows across all active service metrics.
- **Target Metrics:** Zero query drops, SLA adherence (< 2s per rule batch), sustained CPU utilization.

### 2.3 Heavy Analytical Deep Scan Profile
- **Concurrency:** 5 to 20 concurrent analytical queries.
- **Query Patterns:** Broad time windows (7 to 30 days), full-text log search with regex filters, distributed trace span trees.
- **Target Metrics:** Maximum scanned bytes enforcement, streaming memory footprint, graceful timeout enforcement.

---

## 3. Benchmarking Environment Requirements

To produce reproducible, peer-reviewable performance numbers:
- **Dedicated Hardware:** Run on isolated bare-metal or dedicated cloud instances with pinned vCPUs.
- **Isolated Network:** Ensure dedicated 10Gbps+ networking between coordinator, storage cluster, and load generators.
- **Deterministic Workload Scripts:** Store load scripts in version control alongside test configurations.
- **Resource Saturation Logging:** Record CPU, memory, disk I/O, and network bandwidth on both query nodes and storage engines throughout test execution.
