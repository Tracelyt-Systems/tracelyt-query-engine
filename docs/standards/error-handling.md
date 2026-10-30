# Error Handling Standards & Problem Details

This document defines the error representation, HTTP status mapping, error taxonomy, and sanitization rules for `tracelyt-query-engine`.

---

## 1. RFC 9457 Problem Details Standard

All error responses returned by the query engine must adhere to the [RFC 9457 Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457.html) specification using `Content-Type: application/problem+json`.

### Canonical Error Schema

```json
{
  "type": "https://tracelyt.io/errors/query-timeout",
  "title": "Query Execution Timeout",
  "status": 504,
  "detail": "The query exceeded the maximum allowable execution deadline of 30 seconds.",
  "instance": "/queries/qry_9f82b1c4e72a",
  "code": "QUERY_TIMEOUT",
  "timestamp": "2026-10-26T16:20:00.123Z",
  "invalid_params": []
}
```

---

## 2. Standard Error Taxonomy

| Error Code | HTTP Status | Description | Actionable Guidance for Client |
|---|---|---|---|
| `INVALID_QUERY_SYNTAX` | 400 Bad Request | Query parser failed on invalid AST or unexpected token. | Correct syntax error at indicated line and column. |
| `TIME_RANGE_EXCEEDED` | 400 Bad Request | Requested query duration exceeds the maximum permitted window (e.g. > 30 days). | Narrow time range or apply coarser aggregation step. |
| `UNAUTHORIZED` | 401 Unauthorized | Missing or expired authentication token. | Refresh credentials with `tracelyt-control-plane`. |
| `TENANT_ACCESS_DENIED` | 403 Forbidden | Authenticated identity lacks permission for requested tenant/project. | Request tenant role from project administrator. |
| `PAYLOAD_TOO_LARGE` | 413 Payload Too Large | Result row count or byte size exceeded safe limits (> 50MB / 100K rows). | Add limit clause or filter by specific service/label. |
| `RATE_LIMIT_EXCEEDED` | 429 Too Many Requests | Tenant exceeded concurrent query budget or admission queue full. | Back off and retry using exponential jitter. |
| `STORAGE_UNAVAILABLE` | 503 Service Unavailable | Downstream analytical storage backend is unreachable or circuit broken. | Retry after period specified in `Retry-After` header. |
| `QUERY_TIMEOUT` | 504 Gateway Timeout | Execution exceeded query deadline before completing. | Narrow time range, add index-backed filters, or paginate. |

---

## 3. Error Sanitization & Information Leakage Prevention

1. **No Stack Traces:** Java exceptions and stack traces must **never** be included in API response payloads in production environments.
2. **No Storage Dialect Exposure:** Raw database exceptions (e.g., ClickHouse syntax error strings, connection pool credentials, IP addresses) must be caught at the storage boundary and mapped to sanitized, user-friendly problem details.
3. **Redaction of User Filter Values:** If a syntax error occurs in a sensitive field (e.g., an authorization header filter), the error message must redact the sensitive argument value.
