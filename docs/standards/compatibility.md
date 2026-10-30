# API Compatibility & Versioning Policy

This document defines the semantic versioning rules, compatibility guarantees, and deprecation policies governing `tracelyt-query-engine`.

---

## 1. Semantic Versioning

The subsystem follows [Semantic Versioning 2.0.0](https://semver.org/):
- **Major (vX.0.0):** Incompatible API changes, removals of supported query operators, or breaking changes in storage adapter interfaces.
- **Minor (v0.X.0):** Backward-compatible feature additions (e.g., new query aggregation functions, new storage candidate adapters).
- **Patch (v0.0.X):** Backward-compatible bug fixes, security patches, and performance optimizations.

---

## 2. Breaking vs. Non-Breaking Changes

### Non-Breaking Changes (Allowed in Minor / Patch)
- Adding new optional fields to query request payloads with safe defaults.
- Adding new fields to query response envelopes.
- Adding new supported analytical aggregation functions.
- Relaxing execution constraints (e.g., increasing maximum query time window).

### Breaking Changes (Requires Major Version Bump & Deprecation Cycle)
- Renaming or removing existing request parameters or response fields.
- Changing the type, unit, or time format of an existing field (e.g., changing milliseconds to nanoseconds).
- Removing support for a previously supported query syntax or language dialect.
- Tightening mandatory validation rules that cause previously valid queries to fail.

---

## 3. Deprecation Lifecycle

When an API field, parameter, or query operator is designated for removal:
1. **Notice Phase:** Mark as `@Deprecated` in contract schemas (`tracelyt-specs`) and document in `CHANGELOG.md`.
2. **Runtime Warning:** Emit HTTP `Sunset` and `Deprecation` response headers (RFC 8594) when the deprecated capability is invoked.
3. **Grace Period:** Maintain backward compatibility for at least two minor releases (or 6 months) before removal in the next major version.
