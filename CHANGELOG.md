# Changelog

All notable changes to the Tracelyt Query Engine will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project foundation and architectural specifications.
- Java 21 LTS + Spring Boot 3.4.3 bootstrap with ApplicationContext smoke tests.
- Static code analysis integration via Checkstyle 10.21.4 (zero violations).
- Architecture documentation: query lifecycle, storage strategy, multi-language boundaries, scalability, and failure models.
- Operational guides: capacity planning, configuration strategy, resource limits, and observability.
- Security baseline: threat model, tenant isolation principles, data privacy, and supply chain controls.
- CI workflows for continuous integration, documentation verification, and dependency review.
- Open-source governance files: Code of Conduct, Contributing guide, Governance model, Maintainers registry, Security policy, and Support.

> **Note**: Query execution engines (PromQL/LogQL/SQL), storage adapters (ClickHouse/Elasticsearch), distributed workers, and caching are intentionally not implemented in this initial foundation release.
