# Examples

## Unlock in a Pipeline

Two patterns work for git-crypt secrets in a build or deploy:

1. GPG unlock, when CI has a GPG private key
2. Symmetric unlock with `git-crypt export-key`, when CI has only the repo key

### Shared Steps

1.   Store a key (GPG or git-crypt symmetric) as a CI secret
2.   In the workflow:
     1. Install git-crypt, and GPG when you use a GPG key
     2. Check out the repo
     3. Import the key
     4. Run `git-crypt unlock`
     5. Build or deploy using the decrypted files

After unlock, encrypted files look normal in that job's workspace only.

> **Note:** These examples use GitHub Actions. The same approach works for GitLab, Bitbucket, and other CI tools.

## Symmetric Key

This is usually the cleaner option for CI. No GPG is required in the job.

### Export the Key

From the repo root, where git-crypt is already set up:

```bash
git-crypt export-key git-crypt-key
base64 git-crypt-key > git-crypt-key.b64
```

Copy the contents of `git-crypt-key.b64`.

### Store the Secret

In the repo or organisation settings, under Secrets and variables, then Actions:

- Name: `GIT_CRYPT_KEY_B64`
- Value: contents of `git-crypt-key.b64`

### Unlock in the Workflow

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
          echo "$GIT_CRYPT_KEY_B64" | base64 -d > git-crypt-key
          git-crypt unlock git-crypt-key
          rm git-crypt-key

      - name: Build and deploy
        run: |
          ./scripts/build.sh
          ./scripts/deploy.sh
```

If you rotate the git-crypt key, export it again and update `GIT_CRYPT_KEY_B64`.

## GPG Key in CI

Closer to local use, and more steps.

### Export the Private Key

> **Note:** Store this only as a CI secret. Never commit it.

```bash
gpg --export-secret-keys --armor "Your Name (git-crypt)" > git-crypt-private.asc
base64 git-crypt-private.asc > git-crypt-private.asc.b64
```

Add a GitHub Actions secret:

- Name: `GIT_CRYPT_GPG_PRIVATE_B64`
- Value: that base64 string

### Import and Unlock

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
          echo "$GIT_CRYPT_GPG_PRIVATE_B64" | base64 -d > git-crypt-private.asc
          gpg --batch --import git-crypt-private.asc
          rm git-crypt-private.asc
          gpg --list-secret-keys || true
          git-crypt unlock

      - name: Build and deploy
        run: |
          ./scripts/build.sh
          ./scripts/deploy.sh
```

### Security Notes

- Use encrypted CI secrets for the private key
- Prefer a short-lived GPG key for CI
- Keep the CI key's access as narrow as the job needs
