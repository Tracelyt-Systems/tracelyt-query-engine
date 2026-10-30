# Configuration Architecture & Policy

This document establishes the configuration hierarchy, environment variable conventions, startup validation rules, and secret management policies for `tracelyt-query-engine`.

---

## 1. Configuration Principles

1. **Explicit Property Names:** Use clear, namespaced hierarchical property keys (e.g., `tracelyt.query.max-concurrent-queries`).
2. **Documented & Safe Defaults:** Every configuration property must have a documented default that is safe for local developer workstations.
3. **Fail-Fast Startup Validation:** Configuration properties must be strongly typed and validated at application bootstrap using Hibernate Validator / Bean Validation. If required properties are missing or bounds are violated, startup must fail immediately with an explicit error.
4. **Zero Secrets in Repository:** Never commit real passwords, tokens, API keys, or connection credentials. Example files must use unambiguous placeholders (`CHANGE_ME_SECRET`).
5. **Environment Variable Overrides:** All configuration properties must be overridable via standard POSIX environment variables following Spring Boot relaxed binding rules (e.g., `TRACELYT_QUERY_MAX_CONCURRENT_QUERIES`).

---

## 2. Configuration Profiles & Hierarchy

Configuration is loaded through standard Spring Boot mechanisms:

```text
[application.yml (Base Defaults)]
       │
       ▼
[application-<profile>.yml (e.g., test, production)]
       │
       ▼
[Environment Variables (OS / Kubernetes Container Spec)]
```

### Profiles
- **`default` / `dev`:** Configured for local development. Embedded health endpoints on port `8083`.
- **`test`:** Used during Maven test execution ([`src/test/resources/application-test.yml`](../../src/test/resources/application-test.yml)).
- **`production`:** Active in containerized deployments. Enforces strict resource limits and sanitized error payloads.

---

## 3. Current Baseline Configuration

The current foundation defines only application and actuator health properties:

```yaml
server:
  port: 8083

spring:
  application:
    name: tracelyt-query-engine

management:
  endpoints:
    web:
      exposure:
        include: health,info
  endpoint:
    health:
      show-details: when-authorized
      probes:
        enabled: true
```

---

## 4. Planned Future Configuration Parameters (Design Only)

When future query admission and storage capabilities are approved and implemented, they will follow these documented naming conventions:

| Parameter Key | Environment Variable | Default | Description |
|---|---|---|---|
| `tracelyt.query.admission.max-concurrent` | `TRACELYT_QUERY_ADMISSION_MAX_CONCURRENT` | `50` | Maximum queries admitted concurrently per node before queuing. |
| `tracelyt.query.admission.queue-capacity` | `TRACELYT_QUERY_ADMISSION_QUEUE_CAPACITY` | `100` | Maximum queue depth before fast rejection (`429 Too Many Requests`). |
| `tracelyt.query.limits.default-timeout-seconds` | `TRACELYT_QUERY_LIMITS_DEFAULT_TIMEOUT_SECONDS` | `30` | Default execution deadline for user queries. |
| `tracelyt.query.limits.max-scanned-bytes` | `TRACELYT_QUERY_LIMITS_MAX_SCANNED_BYTES` | `10737418240` (10GB) | Maximum bytes scanned per query before termination. |
| `tracelyt.query.limits.max-result-rows` | `TRACELYT_QUERY_LIMITS_MAX_RESULT_ROWS` | `100000` | Hard cap on total rows returned to prevent JVM heap exhaustion. |

> **Notice:** The parameters above represent design requirements for future phases. They are not parsed or loaded by the current foundation code.
