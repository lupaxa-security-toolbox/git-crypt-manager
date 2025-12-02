<p align="center">
  <a href="https://github.com/lupaxa-security-toolbox">
    <img src="https://raw.githubusercontent.com/the-lupaxa-project/org-logos/master/orgs/security-toolbox/readme-logo.png" alt="Project Logo" width="256"/><br/>
  </a>
</p>

<h3 align="center">
  The Lupaxa Security Toolbox<br />
  Part of The Lupaxa Project
</h3>

<br />

<p align="center">
  <!-- Core project badges -->
  <a href="https://github.com/lupaxa-security-toolbox/git-crypt-manager/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/lupaxa-security-toolbox/git-crypt-manager/ci.yml?style=for-the-badge&branch=master&label=build%20status&" alt="Build Status"/>
  </a>
  <a href="https://github.com/lupaxa-security-toolbox/git-crypt-manager/releases/latest">
    <img src="https://img.shields.io/github/v/release/lupaxa-security-toolbox/git-crypt-manager?style=for-the-badge&color=203959&label=Latest%20Release" alt="Latest Release"/>
  </a>
  <a href="https://github.com/lupaxa-security-toolbox/git-crypt-manager/releases">
    <img src="https://img.shields.io/github/release-date/lupaxa-security-toolbox/git-crypt-manager?style=for-the-badge&color=203959&label=Released" alt="Release Date"/>
  </a>
  <a href="https://github.com/lupaxa-security-toolbox/git-crypt-manager/master">
    <img src="https://img.shields.io/github/commits-since/lupaxa-security-toolbox/git-crypt-manager/latest.svg?style=for-the-badge&color=203959" alt="Commits Since Release"/>
  </a>
  <br/>
  <!-- Community & ecosystem badges -->
  <a href="https://github.com/lupaxa-security-toolbox/git-crypt-manager/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/lupaxa-security-toolbox/git-crypt-manager?style=for-the-badge&color=203959" alt="Contributors"/>
  </a>
  <a href="https://github.com/lupaxa-security-toolbox/git-crypt-manager/issues">
    <img src="https://img.shields.io/github/issues/lupaxa-security-toolbox/git-crypt-manager?style=for-the-badge&color=203959" alt="Open Issues"/>
  </a>
  <a href="https://github.com/lupaxa-security-toolbox/git-crypt-manager/pulls">
    <img src="https://img.shields.io/github/issues-pr/lupaxa-security-toolbox/git-crypt-manager?style=for-the-badge&color=203959" alt="Open Pull Requests"/>
  </a>
  <a href="https://github.com/lupaxa-security-toolbox/git-crypt-manager/blob/master/LICENSE.md">
    <img src="https://img.shields.io/github/license/lupaxa-security-toolbox/git-crypt-manager?style=for-the-badge&color=203959&label=License" alt="License"/>
  </a>
  <br />
</p>

<h1 align="center">GCM — Git-Crypt Manager</h1>

A secure, guided automation tool for managing encrypted repositories using [`git-crypt`](https://github.com/AGWA/git-crypt).

`gcm` provides:

- Safe initialization of git-crypt
- Trusted GPG user enforcement (no insecure keys)
- Easy add / rotate / revoke user flows
- Encrypted audit logs for compliance
- Automated git-crypt metadata commits
- `list-users` command for visibility

## Security guarantees

GCM enforces:

- `git-crypt` must be initialized by GCM (not manually)
- Setup must be run **only on a clean repo** (ideally brand new repositories)
- GPG keys must be **fully trusted (`trust = f` or `u`)**
- Logs are stored under `.git-crypt-logs/` and are **encrypted**
- Changes requiring encryption are auto-staged and committed
- No unencrypted sensitive files remain staged/committed

If a key is not trusted, GCM will refuse to use it and show instructions to fix trust.

## Requirements

- bash
- git ≥ 2.20
- git-crypt
- gpg

## Install

Place the script anywhere in your PATH, e.g.:

```bash
git clone https://github.com/lupaxa-security-toolbox/git-crypt-manager
cd git-crypt-manager/src
chmod +x gcm
sudo mv gcm /usr/local/bin/
```

Verify:

```bash
gcm --help
```

## Workflow: Starting a New Secure Repo

> [!IMPORTANT]
> YOU MUST BEGIN WITH A CLEAN EMPTY REPO

```bash
git init secure-repo
cd secure-repo

gcm setup
```

Example output:

```bash
[INFO] Initialising git-crypt…
[OK] Wrote git-crypt .gitattributes rules.
[OK] Committed initial git-crypt setup.
```

This creates:

```bash
.gitattributes
.git-crypt/
.git-crypt-logs/
```

Everything except docs, .github, and Markdown is encrypted.

## Managing Users

### Add users

```bash
gcm add-users
```

Flow:

1. You enter how many
2. You provide GPG key IDs (email / fingerprint / short ID)
3. GCM checks trust and rejects insecure keys
4. Each approved user is added and logged
5. All changes are committed

### Rotate users

Used when someone gets a new GPG key:

```bash
gcm rotate-users
```

Flow:

1. You enter how many
2. You provide the OLD GPG key IDs (email / fingerprint / short ID)
3. User is revoked and logged
4. You provide the NEW GPG key IDs (email / fingerprint / short ID)
5. GCM checks trust and rejects insecure keys
6. Each approved user is added and logged
7. All changes are committed

### Revoke users

Used when a user leaves the project:

```bash
gcm revoke-users
```

Flow:

1. You enter how many
2. You provide GPG key IDs (email / fingerprint / short ID)
3. User is revoked and logged
4. All changes are committed

### View Current Access

```bash
gcm list-users
```

Shows GPG fingerprints & user labels detected in .git-crypt/keys/**/*.

Example:

```text
Current git-crypt users:
 - Bob Smith <bob.smith@example.com> (1234567890ABCDEF)
 - Alice Jones <alice.jones@example.com> (FEDCBA0987654321)
```

## GPG Key Trust Requirements

Keys must be fully trusted (trust = f) or ultimately trusted (trust = u).

How to trust a key

```bash
gpg --edit-key <KEYID>
trust
# Select:
#   4 = Full trust
quit
```

Then retry:

```bash
gcm add-users
```

If trust isn’t set, GCM will not proceed.

## Encryption Rules

.gitattributes created automatically:

```bash
# git-crypt setup (auto-generated)
* filter=git-crypt diff=git-crypt

# Explicit plaintext-only
README.md !filter !diff
*.md !filter !diff
docs/** !filter !diff
.github/** !filter !diff
.gitignore !filter !diff

# Audit logs encrypted:
.git-crypt-logs/** filter=git-crypt diff=git-crypt
```

> [!NOTE]
> This is just the default `paranoid` setup - you can change `.gitattributes` to meet your needs but the initial default is encrypt `everything`.

## Continuous Integration (optional)

To decrypt in CI:

- CI must import a trusted private GPG key
- That key must be added via gcm add-users

Example GitHub workflow snippet:

```yaml
- name: Import GPG key
  run: |
    echo "${GPG_PRIVATE_KEY}" | gpg --batch --import
    git-crypt unlock
```

> [!NOTE]
> For more information of pipelines please refer to the [main documentation](https://lupaxa-security-toolbox.github.io/git-crypt-manager/pipelines/)

If CI only needs plaintext docs or build artifacts, you can avoid unlocking altogether.

## Troubleshooting

| Issue                                         | Fix                                              |
| :-------------------------------------------- | :----------------------------------------------- |
| ERROR: git-crypt is not initialised           | Run gcm setup first.                             |
| untrusted key error                           | Set trust to full (4) in gpg --edit-key.         |
| Files show as unencrypted in git-crypt status | Commit .gitattributes first, then rerun command. |
| git-crypt unlock fails                        | Ensure your GPG private key is loaded & trusted. |

## Logs & Compliance

All operations write structured encrypted JSON logs to:

```bash
.git-crypt-logs/
```

Logs include:

- Timestamp
- Operation
- Result (success/fail)
- Key fingerprint, email (if applicable)

These are encrypted and versioned alongside code.

## Cleanup

Remove all encryption and users (dangerous):

```bash
gcm unencrypt
```

This is a nuclear action — restores the repo to plaintext permanently.

## Commands Summary

| Command          | Description                                |
| :--------------- | :----------------------------------------- |
| gcm setup        | Initialize git-crypt and encryption rules. |
| gcm add-users    | Add one or more trusted GPG users.         |
| gcm list-users   | Show current git-crypt collaborators.      |
| gcm rotate-users | Replace a user’s old key with a new key.   |
| gcm revoke-users | Remove one or more users.                  |
| gcm unencrypt    | Completely disable encryption (dangerous). |
| gcm help         | Show help.                                 |

<h1>&nbsp;</h1>
<p align="center">
    <strong>
        &copy; The Lupaxa Project.
    </strong>
    <br />
    <em>
        Where exploration meets precision.<br />
        Where the untamed meets the engineered.
    </em>
</p>
