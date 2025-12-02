# Unlocking in a pipeline

There are two sane patterns for using git-crypt secrets in a build/deploy:

1. GPG-based unlock (CI has your GPG private key)
2. Symmetric key unlock with git-crypt export-key (CI has only the repo key, no GPG)

## High-level pattern

Regardless of method:

1. Store a key (GPG or git-crypt symmetric) as a CI secret
2. In the workflow:
    1. Install git-crypt (and maybe GPG)
    2. Checkout repo (encrypted files)
    3. Import key
    4. Run git-crypt unlock
    5. Build/deploy using decrypted files

After unlock, all of your encrypted files look normal in the workspace for that job only.

> Although these examples use GitHub pipelines, the same principal will work for GitLab, BitBucket and many other CI tools.

## Option A: Use git-crypt’s symmetric key (no GPG in CI)

This is usually the cleanest for CI.

### On your machine: export the symmetric key

From the repo root (where git-crypt is already set up):

```bash
git-crypt export-key git-crypt-key
```

This creates git-crypt-key (binary, symmetric key file).

Base64 it for safe transport to CI:

```bash
base64 git-crypt-key > git-crypt-key.b64
```

Open git-crypt-key.b64 and copy its contents.

### Add it as a GitHub Actions secret

In the repo/org settings → Secrets and variables → Actions:

- Name: GIT_CRYPT_KEY_B64
- Value: contents of git-crypt-key.b64

### In your workflow: decode & unlock

Example workflow snippet:

```yaml
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
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

          # Decode symmetric key into a file
          echo "$GIT_CRYPT_KEY_B64" | base64 -d > git-crypt-key

          # Unlock the repo using the symmetric key
          git-crypt unlock git-crypt-key

          # optional: remove the key file after unlock
          rm git-crypt-key

      - name: Build / deploy
        run: |
          # At this point, encrypted files are in plaintext
          ./scripts/build.sh
          ./scripts/deploy.sh
```

Notes:

- No GPG needed in CI at all.
- If you ever rotate the git-crypt key (e.g. git-crypt export-key again after revoke-gpg-user), just update GIT_CRYPT_KEY_B64.

## Option B: Use your GPG key in CI

This is closer to what we’ve been doing locally, but a bit more faff.

### On your machine: export your GPG private key

> Handle this carefully. Only store it as a CI secret, never in the repo.

```bash
gpg --export-secret-keys --armor "Your Name (git-crypt)" > git-crypt-private.asc
base64 git-crypt-private.asc > git-crypt-private.asc.b64
```

Copy the contents of git-crypt-private.asc.b64.

Add to GitHub Actions secrets:

- Name: GIT_CRYPT_GPG_PRIVATE_B64
- Value: that base64 string

(Optionally also export ownertrust, but often not needed for CI.)

### In your workflow: import key + unlock

```yaml
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Install git-crypt and gnupg
        run: |
          sudo apt-get update
          sudo apt-get install -y git-crypt gnupg

      - name: Import GPG key and unlock git-crypt
        env:
          GIT_CRYPT_GPG_PRIVATE_B64: ${{ secrets.GIT_CRYPT_GPG_PRIVATE_B64 }}
        run: |
          set -euo pipefail

          # Import private key
          echo "$GIT_CRYPT_GPG_PRIVATE_B64" | base64 -d > git-crypt-private.asc
          gpg --batch --import git-crypt-private.asc
          rm git-crypt-private.asc

          # Optional but helpful: list keys for debugging (without private material)
          gpg --list-secret-keys || true

          # Unlock repo (git-crypt will use the imported key)
          git-crypt unlock

      - name: Build / deploy
        run: |
          ./scripts/build.sh
          ./scripts/deploy.sh
```

Security Notes

- Use GitHub Encrypted Secrets for GPG_PRIVATE_KEY
- Use short-lived ephemeral GPG keys for CI when possible
- Avoid giving CI overly broad access
