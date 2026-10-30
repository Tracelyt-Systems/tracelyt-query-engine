# Query Engine Contracts and Schema Governance

This directory is designated for referencing shared interface contracts and API definitions consumed or provided by `tracelyt-query-engine`.

---

## 1. Canonical Source of Truth

> [!IMPORTANT]
> **Contracts are Governed in `tracelyt-specs`**  
> In accordance with Tracelyt platform architecture, all shared API contracts, error schemas, pagination standards, and cross-service message definitions are governed centrally in the [`tracelyt-specs`](https://github.com/Tracelyt-Systems/tracelyt-specs) repository.  
> **This repository does not invent proprietary or competing contract formats independently.**

---

## 2. Planned Query Contracts

When product requirements and query workflows are approved, future contracts will define:

1. **Query API Definitions**:
   - Synchronous HTTP REST/JSON endpoints (OpenAPI 3.1) for dashboard queries and trace waterfalls.
   - High-throughput binary streaming interfaces (gRPC/Arrow) for bulk analytical export where appropriate.
2. **Standard Error Envelopes**:
   - RFC 9457 Problem Details (`application/problem+json`) with machine-readable error codes (`type`, `title`, `status`, `detail`, `invalidParams`).
3. **Time-Range and Resolution Conventions**:
   - Explicit UTC timestamp ranges (`start`, `end`) and step intervals (`step`).
4. **Result Pagination & Limits**:
   - Cursor-based or bounded offset pagination with maximum row and byte caps.
5. **Tenant Context Headers**:
   - Standardized tenant and project identifiers propagated securely from authenticated sessions.

---

## 3. Contributing Contract Changes

To propose a new contract or update an existing query schema:
1. Propose an RFC in [`tracelyt-specs`](https://github.com/Tracelyt-Systems/tracelyt-specs).
2. Follow the 10-step contract change lifecycle documented in `tracelyt-specs/docs/development/contributing-contracts.md`.
3. Once approved and published, bind the query engine implementation to the canonical specification.
