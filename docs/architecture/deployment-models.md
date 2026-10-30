# Deployment Models and Topology

This document describes the deployment topologies supported by the Tracelyt Query Engine architecture.

---

## 1. Deployment Topologies

The query engine is architected to support two deployment profiles depending on scale and operational complexity:

### 1.1 Embedded / Standalone Profile (Developer & Small Deployments)
In lightweight or self-hosted deployments:
- A single query engine instance handles API routing, query planning, and direct storage adapter reads.
- Ideal for development environments, single-node Docker Compose stacks, and small enterprise footprints (< 100 queries/min).
- Minimal infrastructure overhead: zero distributed coordinators or worker message queues required.

### 1.2 Distributed Coordinator-Worker Profile (Enterprise Scale)
In high-throughput, multi-tenant cloud installations:
- **Stateless Query Coordinators**: Receive incoming API requests from clients, validate authentication, enforce tenant quotas, split queries into temporal partition chunks, and aggregate final results.
- **Query Worker Pool**: Horizontally auto-scaled stateless workers that execute sub-queries against underlying database shards in parallel.
- Workers scale independently based on CPU utilization and query queue depths.

---

## 2. Separation of Deployment Responsibility

In alignment with platform system boundaries:
- `tracelyt-query-engine` defines the application packaging (runnable JAR, minimal non-root Dockerfile, health probes, and JVM configuration).
- Platform-wide deployment manifests (Kubernetes Helm charts, Docker Compose topologies, cloud Terraform modules) are owned and maintained by the **`tracelyt-deploy`** repository.
