# Repository Tooling and Validation Scripts

This directory contains utility scripts for validating documentation integrity, repository hygiene, and static standards in `tracelyt-query-engine`.

---

## Active Tools

### `tools/validate_docs.py`
A dependency-free Python script (Python 3.10+) that performs:
- **Relative Link Resolution**: Verifies that all internal Markdown links point to existing files.
- **UTF-8 Encoding Checks**: Ensures documentation files are encoded in clean UTF-8.
- **Secret Scanning Heuristics**: Identifies accidental credential-like strings or private keys in tracked source files.

Run locally:
```bash
python tools/validate_docs.py
```
Or via Makefile:
```bash
make docs-check
```
