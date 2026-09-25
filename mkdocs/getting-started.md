# Getting Started

GCM must be run inside a Git repository.

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

Or place the script on your `PATH`:

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

## New Repository

```bash
git init my-secure-repo
cd my-secure-repo
gcm setup
```

This performs:

1. Initialise git-crypt
2. Create `.gitattributes` with secure defaults
3. Commit setup and an encrypted log entry

## Existing Repository

Supported when the repository is clean:

```bash
git status  # must show nothing to commit
gcm setup
```

> **Note:** Files already committed stay plaintext in history. Rewrite history yourself if that content must be removed.

## Gitattributes Rules

Created and updated automatically:

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

> **Note:** This is the default paranoid setup. You can change `.gitattributes` to meet your needs. The initial default encrypts everything except the plaintext rules above.

## Generate a GPG Key

GCM allows only trusted keys. Unknown or marginal trust is rejected.

```bash
gpg --quick-generate-key "Your Name (git-crypt) <your.name@example.com>" rsa4096 sign,cert,encrypt 2y
```

> **Note:** The `encrypt` capability is required. Without it the key cannot be used with git-crypt.

## Export and Import a Key

```bash
gpg --list-secret-keys --keyid-format=long
gpg --armor --export <ID> > mykey.asc
```

The exported public key is safe to share. Import it on another machine:

```bash
gpg --import mykey.asc
```

List keys and fingerprints:

```bash
gpg --list-keys
gpg --fingerprint <KEYID>
```

## Trust a Key

```bash
gpg --edit-key <KEYID>
trust
# choose option 4 = full trust
quit
```

Full trust (`f`) or ultimate trust (`u`) is required before `gcm add-users`.

## After Setup

Add users, then push:

```bash
gcm add-users
git remote add origin <url>
git push -u origin master
```
