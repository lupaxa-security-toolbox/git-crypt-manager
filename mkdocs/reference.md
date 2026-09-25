# Reference

## Security Model

GCM is designed for zero plaintext leakage once encryption is enabled.

### Threat Controls

| Mitigation                    | Purpose                               |
| :---------------------------- | :------------------------------------ |
| Trusted keys required         | Prevent unauthorized access.          |
| Auto-commit metadata          | Prevent staging plaintext content.    |
| Encrypted access logs         | Forensic accountability.              |
| Clean-repo enforcement        | Avoid accidental unencrypted commits. |
| Explicit plaintext-only rules | Docs and CI configs remain readable.  |

### What GCM Does Not Cover

- Existing plaintext history requires a manual rewrite (`git-filter-repo` or similar)
- A compromised GPG key must be rotated immediately with `gcm rotate-user`
- A compromised user device must be revoked with `gcm revoke-user`

### Security Practices

- Run `gcm setup` before adding sensitive files
- Use a hardware token such as a YubiKey for GPG
- Audit active users with `gcm list-users`

## Audit Logs

Every operation that changes access control is logged under `.git-crypt-logs/` and encrypted with git-crypt.

Logs include:

- Operation type (`add-user`, `rotate-user`, `revoke-user`, and others)
- Timestamp
- GPG fingerprint and identity
- Result status

Example filename:

```text
.git-crypt-logs/20251128T103754Z-add-user.json
```

## Troubleshooting

### Repository is not Clean

```bash
git add -A
git commit -m "Save before encryption"
```

or:

```bash
git stash
```

### Key is not Trusted

```text
ERROR: GPG key is NOT trusted enough
```

Fix:

```bash
gpg --edit-key <KEYID>
trust
4
quit
```

Then rerun the command.

### Git-Crypt is not Initialised

```bash
gcm setup
git add .gitattributes
git commit -m "Initialize git-crypt"
```

### Encrypted Files are Unreadable

```bash
git-crypt unlock
```

### Missing Gitattributes Rules

```bash
gcm setup
git add .gitattributes
git commit -m "Apply git-crypt attributes"
```
