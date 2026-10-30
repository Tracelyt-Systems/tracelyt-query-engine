# Security Policy

## Security Expectations for Query Engine

The Tracelyt Query Engine will eventually serve as the primary data retrieval gateway for observability telemetry across metrics, logs, and distributed traces. Because query engines execute potentially complex analytical aggregations and operate directly on sensitive historical records across multi-tenant boundaries, security is a first-class requirement.

### Key Principles

1. **No Sensitive Data or Live Credentials**: Tracked files must never contain actual credentials, tokens, API keys, private certificates, internal hostnames, or production customer telemetry. All examples and tests must use synthetic placeholders.
2. **Tenant Isolation by Construction**: Future query execution paths must enforce tenant boundaries based on validated cryptographic identity tokens, never trusting client-supplied query parameters alone.
3. **Defense Against Query-Based Denial of Service**: All future query execution paths must enforce query deadlines, cancellation propagation, row count caps, and memory budgets.

## Reporting a Security Vulnerability

We request that security researchers and contributors report suspected vulnerabilities in a coordinated and responsible manner.

### Preferred Reporting Method

1. **GitHub Private Vulnerability Reporting**:
   - Check if [GitHub Private Vulnerability Reporting](https://github.com/Tracelyt-Systems/tracelyt-query-engine/security/advisories) is enabled on this repository.
   - If enabled, click **Report a vulnerability** to submit an advisory directly to repository maintainers.
   - *Note for Maintainers*: Repository maintainers must verify and enable this feature under repository **Settings > Code security and analysis > Private vulnerability reporting**.

2. **Direct Maintainer Contact via GitHub**:
   - If Private Vulnerability Reporting is not active, reach out to the project maintainers listed in [.github/CODEOWNERS](.github/CODEOWNERS) or [MAINTAINERS.md](MAINTAINERS.md) via their verified GitHub profiles.
   - Do **not** disclose potential security issues, exploit demonstrations, or affected telemetry payloads in publicly accessible GitHub issues, pull request comments, or public discussions.

### Information to Include in Reports

To help us triage and resolve the issue efficiently, please include:
- A clear description of the vulnerability (e.g., authorization bypass, cross-tenant data leakage, query injection, memory exhaustion).
- The affected file path and commit SHA or release version.
- Step-by-step reproduction instructions or a minimal test query triggering the issue.
- Impact assessment on the query subsystem.

### Vulnerability Handling Process

1. **Acknowledgment**: Maintainers will review the submission and acknowledge receipt.
2. **Assessment**: The impact on the query engine and dependent Tracelyt services will be evaluated.
3. **Remediation**: A coordinated fix will be prepared in a private advisory workspace.
4. **Disclosure**: A public advisory and release will be published in accordance with coordinated disclosure practices.
