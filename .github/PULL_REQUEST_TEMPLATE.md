## Summary of Changes

A concise description of what this pull request introduces or modifies.

## Classification

- [ ] Architectural Documentation / Governance
- [ ] Build Configuration / CI Tooling
- [ ] Application Bootstrap / Setup
- [ ] Security / Privacy Control
- [ ] Bug Fix

## Architectural Context

- **Associated Issue**: Fixes #
- **Component Boundary**: `tracelyt-query-engine`
- **Scope Verification**:
  - [ ] Confirms no unapproved query execution engines, database drivers, or production endpoints are introduced prematurely.
  - [ ] Confirms that cross-service contracts align with [tracelyt-specs](https://github.com/Tracelyt-Systems/tracelyt-specs).

## Quality & Security Checklist

- [ ] Local build passes: `./mvnw clean test checkstyle:check`
- [ ] 0 Checkstyle violations.
- [ ] No secrets, tokens, internal URLs, or customer telemetry in code or commits.
- [ ] All new documentation links are relative and functional.
