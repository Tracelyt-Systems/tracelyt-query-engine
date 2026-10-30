# Data Privacy & Telemetry Minimization

This document outlines privacy principles, sensitive data protection, query auditing, and data minimization strategies for `tracelyt-query-engine`.

> **Important Notice:** This document establishes engineering design principles for data privacy. Tracelyt does not claim formal certification or compliance with GDPR, HIPAA, SOC 2, or ISO 27001 based solely on the existence of these architectural guidelines.

---

## 1. Principles of Data Privacy

Observability platforms inadvertently collect high volumes of sensitive telemetry, including user IP addresses, session identifiers, Bearer tokens in headers, email addresses in log messages, and database query parameters. The query engine must implement strict controls to minimize exposure:

1. **Data Minimization:** Query responses should return only the fields, labels, and time ranges specifically requested by the client.
2. **Masking & Redaction:** Sensitive attributes (e.g., `authorization`, `cookie`, `password`, `ssn`) must be masked or redacted before reaching user dashboards.
3. **No Telemetry in Coordinator Logs:** The query engine itself must **never** write raw query result payloads or telemetry contents into its own operational log files.
4. **Immutable Audit Trails:** Query submissions, tenant scopes, accessed time ranges, and client identities must be recorded in access audit logs for administrative accountability.

---

## 2. Privacy Responsibilities Across Platform Subsystems

| Subsystem | Privacy Responsibility | Boundary with Query Engine |
|---|---|---|
| `tracelyt-ingestion` | Initial ingestion-time masking, drop rules, and field stripping | Sanitizes telemetry before persistent storage write. |
| `tracelyt-control-plane` | Manages tenant roles, RBAC permissions, and field-level masking rules | Distributes authorization and field masking policies to query engine. |
| `tracelyt-query-engine` | Enforces query-time masking, tenant isolation, and audit logging | Ensures unauthorized users cannot view raw unredacted fields. |
| Storage Backends | Enforces TTL-based data retention, physical deletion, and encryption at rest | Executes data lifecycle and partition deletion policies. |

---

## 3. Data Residency & Retention

- **Data Residency:** In multi-region deployments, query requests must be routed only to storage clusters located within the legally approved geographic jurisdiction of the tenant.
- **Retention Lifecycles:** Query engine nodes do not own data retention or physical deletion; persistent storage backends manage TTLs. The query engine must respect retention limits by rejecting queries requesting data older than the configured tenant retention window.

---

## 4. Query Audit Logging

To ensure security accountability, all executed queries should generate a structured audit event containing:
- `timestamp`: UTC ISO-8601 query submission time.
- `tenant_id` & `project_id`: Cryptographically verified tenant scope.
- `user_id` / `client_id`: Authenticated caller identity.
- `signal_type`: `metrics`, `logs`, or `traces`.
- `query_hash`: One-way SHA-256 hash of the normalized query AST (avoiding raw query strings that may contain secrets).
- `time_range`: Start and end timestamps of queried data.
- `status`: `SUCCESS`, `DENIED`, `TIMEOUT`, `CANCELLED`, or `ERROR`.
- `rows_scanned` & `bytes_returned`: Resource impact metrics.
