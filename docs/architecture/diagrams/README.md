# Architecture Diagrams

This directory provides architectural diagrams modeling the planned system context, query flow, and trust boundaries for `tracelyt-query-engine`.

---

## 1. Sequence Diagram: Planned Query Execution

```mermaid
sequenceDiagram
    autonumber
    actor Client as Dashboard / User Client
    participant CP as tracelyt-control-plane
    participant QE as tracelyt-query-engine
    participant Store as Storage Backend (ClickHouse)

    Client->>CP: Authenticate & Submit Query
    CP->>QE: Forward Query + Cryptographic Tenant Context
    activate QE
    QE->>QE: Validate Time Range & Complexity
    QE->>QE: Check Tenant Concurrency Quotas
    alt Quota Exceeded or Invalid Query
        QE-->>Client: 429 Too Many Requests / 400 Bad Request
    else Admitted
        QE->>Store: Execute Partition-Pruned Query (with Deadline)
        activate Store
        Store-->>QE: Stream Result Rows
        deactivate Store
        QE->>QE: Normalize & Redact Sensitive Attributes
        QE-->>Client: 200 OK (Normalized Observability Payload)
    end
    deactivate QE
```

---

## 2. Trust Boundary Diagram

```mermaid
flowchart TD
    subgraph UntrustedZone["Untrusted Network"]
        USER["Browser Client / External API"]
    end

    subgraph EdgeBoundary["Edge Security Boundary"]
        GATEWAY["tracelyt-control-plane\n(TLS Termination · JWT Validation)"]
    end

    subgraph InternalPlatform["Internal Platform Network (Authenticated)"]
        QE["tracelyt-query-engine\n(Tenant Admission · Query Planner)"]
        STORE[("Columnar Database\n(ClickHouse / TSDB)")]
    end

    USER -->|HTTPS Query Request| GATEWAY
    GATEWAY -->|Validated Internal Context| QE
    QE -->|Internal Query (Deadline Bounded)| STORE
```

*Note: These diagrams illustrate planned system architecture; runtime services and database nodes are not yet deployed.*
