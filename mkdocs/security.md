# 🔐 Security Model

GCM is designed for **zero plaintext leakage** once encryption is enabled.

## Threat Controls

| Mitigation                    | Purpose                               |
| :---------------------------- | :------------------------------------ |
| Trusted keys required         | Prevent unauthorized access.          |
| Auto-commit metadata          | Prevent staging plaintext content.    |
| Encrypted access logs         | Forensic accountability.              |
| Clean-repo enforcement        | Avoid accidental unencrypted commits. |
| Explicit plaintext-only rules | Docs & CI configs remain readable.    |

## What GCM Does *Not* Cover

- Existing plaintext history → requires manual rewrite (BFG, git-filter-repo)
- GPG key compromise → rotate immediately via `gcm rotate-users`
- User device compromise → revoke via `gcm revoke-users`

## Security Best Practices

- Run `gcm setup` before adding sensitive files
- Use strong GPG tokens (YubiKey highly recommended)
- Periodically audit active users via `gcm list-users`
