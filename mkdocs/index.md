# Lupaxa GCM — Git-Crypt Manager

GCM is a secure workflow assistant for managing repository encryption with [`git-crypt`](https://github.com/AGWA/git-crypt).

It automates:

- Setup of bidirectional encryption rules
- Trusted GPG key access control
- Add / rotate / revoke git-crypt collaborators
- Listing active encryption users
- Encrypted audit logging

GCM enforces security best practices:

| Area           | Guarantee                                          |
| :------------- | :------------------------------------------------- |
| Repo state     | Must be clean before operations.                   |
| User control   | Keys must be *fully* trusted (trust = `f` or `u`). |
| Logs           | Stored encrypted under `.git-crypt-logs/`.         |
| History safety | Never forces rewrite of existing commits.          |
| Automation     | Metadata auto-commit ensures no plaintext leaks.   |

## Quick Start

```bash
git init secure-repo
cd secure-repo

gcm setup
gcm add-users
```

See [Usage](usage.md) for all commands.
