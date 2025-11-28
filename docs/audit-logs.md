# Encrypted Audit Logs

Every operation that changes access controls is logged to: `.git-crypt-logs/`

and encrypted via git-crypt.

Logs include:

- Operation type (`add-users`, `rotate-users`, `revoke-users`)
- Timestamp
- GPG fingerprint + identity
- Result status

Example filename:

```bash
.git-crypt-logs/20251128T103754Z-add-user.json
```

These logs ensure **compliance + forensic traceability**.
