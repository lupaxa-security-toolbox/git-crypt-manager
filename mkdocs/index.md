# Git Crypt Manager

GCM is a secure workflow assistant for managing repository encryption with [`git-crypt`](https://github.com/AGWA/git-crypt).

It automates:

- Setup of bidirectional encryption rules
- Trusted GPG key access control
- Add, rotate, and revoke git-crypt collaborators
- Listing active encryption users
- Encrypted audit logging

GCM enforces security best practices:

| Area           | Guarantee                                           |
| :------------- | :-------------------------------------------------- |
| Repo state     | Must be clean before operations.                    |
| User control   | Keys must be *fully* trusted (trust = `f` or `u`).  |
| Logs           | Stored encrypted under `.git-crypt-logs/`.          |
| History safety | Never forces rewrite of existing commits.           |
| Automation     | Metadata auto-commit ensures no plaintext leaks.    |

## Install

With Homebrew:

```bash
brew tap the-lupaxa-project/tap
brew trust the-lupaxa-project/tap
brew install git-crypt-manager
```

The command is `gcm`.

## Quick Start

```bash
git init secure-repo
cd secure-repo

gcm setup
gcm add-users
```

See [Getting Started](getting-started.md) for install and setup, and [Usage](usage.md) for commands.
