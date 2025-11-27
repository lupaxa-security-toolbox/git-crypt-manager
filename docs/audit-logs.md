# Audit Logging

Log location:

```text
.git-crypt-logs/YYYYMMDDTHHMMSSZ-.json
```

Information stored:

- timestamp
- version
- action
- actor git identity
- actor GPG identity
- result
- warnings (if any)
- key fingerprint and email (when relevant)

All logs encrypted automatically via git-crypt.

Logs are suitable for:

- Compliance reporting
- Security auditing
- Incident reviews
- Developer accountability

JSON logs are machine-parsable for CI integration or dashboards.
