<p align="center">
  <a href="https://github.com/lupaxa-security-toolbox">
    <img src="https://raw.githubusercontent.com/the-lupaxa-project/brand-assets/master/logos/organisations/security-toolbox/readme-logo.png" alt="Project Logo" width="256"/><br/>
  </a>
</p>

<h1 align="center">Git Crypt Manager</h1>

A secure, guided automation tool for managing encrypted repositories using [`git-crypt`](https://github.com/AGWA/git-crypt).

`gcm` provides:

- Safe initialization of git-crypt
- Trusted GPG user enforcement (no insecure keys)
- Easy add / rotate / revoke user flows
- Encrypted audit logs for compliance
- Automated git-crypt metadata commits
- `list-users`, `doctor`, `backup`, and `restore` for day-to-day ops

## Security Guarantees

GCM enforces:

- Setup must be run **only on a clean repo** (ideally brand new repositories)
- GPG keys must be **fully trusted (`trust = f` or `u`)**
- Logs are stored under `.git-crypt-logs/` and are **encrypted**
- Collaborator metadata changes are auto-staged and committed
- History is never force-rewritten by GCM

If a key is not trusted, GCM will refuse to use it and show instructions to fix trust.

What GCM does **not** cover:

- Existing plaintext history (rewrite with `git-filter-repo` or similar if needed)
- A compromised GPG key — rotate immediately with `gcm rotate-user`
- A compromised user device — revoke with `gcm revoke-user`

## Requirements

- bash
- git ≥ 2.20
- git-crypt
- gpg

## Install

With Homebrew:

```bash
brew tap the-lupaxa-project/tap
brew trust the-lupaxa-project/tap
brew install git-crypt-manager
```

The command is `gcm`. Homebrew also installs `git`, `git-crypt`, and GnuPG.

Or place the script anywhere in your `PATH`:

```bash
git clone https://github.com/lupaxa-security-toolbox/git-crypt-manager
cd git-crypt-manager/src
chmod +x gcm
sudo mv gcm /usr/local/bin/
```

Verify:

```bash
gcm help
```

## Starting a New Secure Repo

> [!IMPORTANT]
> YOU MUST BEGIN WITH A CLEAN EMPTY REPO

```bash
git init secure-repo
cd secure-repo

gcm setup
```

This initialises git-crypt, writes `.gitattributes`, and commits setup plus an encrypted log entry.

Creates:

```text
.gitattributes
.git-crypt/
.git-crypt-logs/
```

Everything except docs, `.github`, and Markdown is encrypted by default.

### Existing Repository

Supported when the working tree is clean:

```bash
git status   # must show nothing to commit
gcm setup
```

> [!NOTE]
> Files already committed stay plaintext in history. Rewrite history yourself if that content must be removed.

After setup, add collaborators and push:

```bash
gcm add-users
git remote add origin <url>
git push -u origin master
```

## GPG Keys

GCM only accepts keys with **full** (`f`) or **ultimate** (`u`) trust. The key must have the **encrypt** capability.

### Generate a Key

```bash
gpg --quick-generate-key "Your Name (git-crypt) <your.name@example.com>" rsa4096 sign,cert,encrypt 2y
```

### Export and Import a Public Key

```bash
gpg --list-secret-keys --keyid-format=long
gpg --armor --export <ID> > mykey.asc
gpg --import mykey.asc   # on another machine
gpg --fingerprint <KEYID>
```

### Trust a Key

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

## Managing Users

Interactive prompts are used when key arguments are omitted. You can also pass keys on the command line.

### Add Users

```bash
gcm add-users
# or:
gcm add-users alice@example.com bob@example.com
```

Flow:

1. Provide GPG key IDs (email / fingerprint / short ID)
2. GCM checks trust and rejects insecure keys
3. Each approved user is added and logged
4. Metadata changes are committed

### Rotate a Key

Used when someone gets a new GPG key. The **new** key is added first, then the old key is revoked, so a failed add does not lock the user out.

```bash
gcm rotate-user
# or:
gcm rotate-user old@example.com new@example.com
```

### Revoke Users

```bash
gcm revoke-user
# or:
gcm revoke-user alice@example.com
```

Typical cases: employee leaves, contract ends, or a key is compromised.

### View Current Access

```bash
gcm list-users
```

Shows fingerprints (and local GPG UIDs when available) under `.git-crypt/keys/`.

## Encryption Rules

`.gitattributes` created automatically:

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
> This is the default paranoid setup — encrypt everything except the plaintext carve-outs above. You can edit `.gitattributes` after setup if you need a narrower filter set.

## Continuous Integration

Two unlock patterns work in CI:

1. **Symmetric key** (usually cleaner — no GPG in the job)
2. **GPG private key** (closer to local use)

### Symmetric Key (Recommended for CI)

Export from a repo that already has git-crypt set up:

```bash
git-crypt export-key git-crypt-key
base64 git-crypt-key > git-crypt-key.b64
```

Store the base64 contents as a CI secret named `GIT_CRYPT_KEY_B64`, then unlock in the workflow:

```yaml
- name: Checkout
  uses: actions/checkout@v4

- name: Install git-crypt
  run: |
    sudo apt-get update
    sudo apt-get install -y git-crypt

- name: Restore git-crypt key and unlock
  env:
    GIT_CRYPT_KEY_B64: ${{ secrets.GIT_CRYPT_KEY_B64 }}
  run: |
    set -euo pipefail
    echo "$GIT_CRYPT_KEY_B64" | base64 -d > git-crypt-key
    git-crypt unlock git-crypt-key
    rm git-crypt-key
```

If you regenerate the git-crypt key, export again and update the secret.

### GPG Key in CI

Store an armored private key (base64) as `GIT_CRYPT_GPG_PRIVATE_B64`. Prefer a short-lived CI-only key with narrow access.

```yaml
- name: Install git-crypt and gnupg
  run: |
    sudo apt-get update
    sudo apt-get install -y git-crypt gnupg

- name: Import GPG key and unlock git-crypt
  env:
    GIT_CRYPT_GPG_PRIVATE_B64: ${{ secrets.GIT_CRYPT_GPG_PRIVATE_B64 }}
  run: |
    set -euo pipefail
    echo "$GIT_CRYPT_GPG_PRIVATE_B64" | base64 -d > git-crypt-private.asc
    gpg --batch --import git-crypt-private.asc
    rm git-crypt-private.asc
    git-crypt unlock
```

If CI only needs plaintext docs or build artifacts, you can skip unlocking altogether.

## Diagnostics and Backup

```bash
gcm doctor     # read-only health check (does not stage or commit)
gcm backup     # copy .git-crypt + .gitattributes into .git-crypt-backups/
gcm restore    # restore the latest local backup
```

Backups contain key material. Keep `.git-crypt-backups/` out of git (GCM adds it to `.gitignore` on setup / backup).

## Troubleshooting

| Issue                                         | Fix                                                              |
| :-------------------------------------------- | :--------------------------------------------------------------- |
| ERROR: git-crypt is not initialised           | Run `gcm setup` first.                                           |
| untrusted key error                           | Set trust to full (4) in `gpg --edit-key`.                       |
| Repository is not clean                       | Commit or `git stash`, then retry.                               |
| Files show as unencrypted in git-crypt status | Commit `.gitattributes` first, then rerun.                       |
| git-crypt unlock fails                        | Ensure your GPG private key (or symmetric key) is loaded.        |
| Encrypted files unreadable locally            | Run `git-crypt unlock`.                                          |

## Logs and Compliance

All mutating access-control operations write structured encrypted JSON logs to:

```text
.git-crypt-logs/
```

Logs include timestamp, operation, result, and key fingerprint / identity when applicable. They are encrypted and versioned alongside the repo.

## Cleanup

Remove the auto-generated git-crypt rules for **future** commits:

```bash
gcm unencrypt
```

This does **not** decrypt historical commits. Existing ciphertext stays encrypted in history.

To regenerate the repo encryption key (dangerous — re-add users and renormalise afterwards):

```bash
gcm nuclear-rotate
```

## Commands Summary

| Command              | Description                                              |
| :------------------- | :------------------------------------------------------- |
| `gcm setup`          | Initialise git-crypt and encryption rules (clean repo).  |
| `gcm add-users`      | Add one or more trusted GPG users.                       |
| `gcm list-users`     | Show current git-crypt collaborators.                    |
| `gcm rotate-user`    | Replace a user's old key with a new key.                 |
| `gcm revoke-user`    | Remove one or more users.                                |
| `gcm doctor`         | Read-only diagnostics.                                   |
| `gcm backup`         | Backup `.git-crypt` and `.gitattributes`.                |
| `gcm restore`        | Restore the latest local backup.                         |
| `gcm nuclear-rotate` | Regenerate the encryption key (dangerous).               |
| `gcm unencrypt`      | Remove encryption rules for future commits.              |
| `gcm help`           | Show help.                                               |

## Practices

- Run `gcm setup` before adding sensitive files
- Prefer a hardware token (for example a YubiKey) for GPG
- Audit active users with `gcm list-users`

<a href="https://github.com/the-lupaxa-project">
    <img src="https://raw.githubusercontent.com/the-lupaxa-project/brand-assets/master/logos/components/footer-for-child-orgs.svg" alt="The Lupaxa Project Footer" width="100%" />
</a>
