<!-- markdownlint-disable -->
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

# git-crypt Manager

Secure lifecycle management for git-crypt encrypted repositories.

Version: v1.0.0
Cross-platform: macOS (BSD) + Linux (GNU)

## Features

- Automated git-crypt setup
- Add, rotate, revoke users (GPG)
- Nuclear re-encryption
- Remove encryption going forward
- Encrypted JSON audit logs
- Backup & restore git-crypt metadata
- Trust enforcement & confirmations
- Secret leak detection in doctor
- Menu UI + CLI mode
- Shell completion support for Bash

## Requirements

- git
- gpg (GnuPG-2 recommended)
- git-crypt

## Installation

Place this script in your PATH and make executable:

```bash
chmod +x git-crypt-manager
mv git-crypt-manager /usr/local/bin/
```

(Optional) Enable Bash auto-completion:

```bash
source git-crypt-manager-completion.bash
```

## Usage

Interactive menu:

```bash
git-crypt-manager
```

Command-line usage:

```bash
git-crypt-manager setup
git-crypt-manager add-users
git-crypt-manager rotate-user
git-crypt-manager revoke-user
git-crypt-manager nuclear-rotate
git-crypt-manager unencrypt
git-crypt-manager doctor
git-crypt-manager backup
git-crypt-manager restore
```

Show version:

```bash
git-crypt-manager --version
```

## Audit Logs

All operations generate encrypted JSON logs under:

```text
.git-crypt-logs/YYYYMMDDTHHMMSSZ-<action>.json
```

Example:

```text
{
    "timestamp": "2025-11-27T17:45:12Z",
    "version": "0.1.0",
    "action": "add-user",
    "actor_git": "Some Person <some.person@example.com>",
    "result": "success"
}
```

Logs are encrypted by git-crypt so **safe for commit & sync**.

## Trust Enforcement

Keys should be:

- ultimate or full trust

If trust is marginal or unknown: → warning + user confirmation required

To change trust:

```bash
gpg --edit-key <KEYID>
trust
(select full)
quit
```

## First-time Secure Repo Setup

```bash
git init secure-repo
cd secure-repo

git-crypt-manager setup
git-crypt-manager add-users

git add --renormalize .
git commit -m "Enable git-crypt encryption"
git push
```

New users unlock:

```bash
git clone …
git-crypt unlock
```

## Rotating Keys

Single user:

```bash
git-crypt-manager rotate-user
git commit -am "Rotate access"
git push
```

Complete re-encryption:

```bash
git-crypt-manager nuclear-rotate
git add --renormalize .
git commit -m "Re-encrypt entire repo"
git push
```

## Remove Encryption Going Forward

```bash
git-crypt-manager unencrypt
git add --renormalize .
git commit -m "Remove git-crypt"
git push
```

> Past commits remain encrypted

## Backup / Restore

Backup:

```bash
git-crypt-manager backup
```

Restore most recent:

```bash
    git-crypt-manager restore
```

## Recommended Team Workflow

1. Developer generates GPG key
2. Maintainer imports + trusts key
3. Maintainer adds user using this tool
4. Commit & push to sync access
5. When a developer leaves → revoke key
6. If in doubt → nuclear rotation

## Troubleshooting

git-crypt not unlocked:

```bash
git-crypt unlock
```

Check repo health:

```bash
git-crypt-manager doctor
```

<footer>
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
</footer>
