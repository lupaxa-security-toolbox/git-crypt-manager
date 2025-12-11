# 🔧 Repository Setup

GCM must be run **inside a Git repository**.

## New Repo (Recommended)

```bash
git init my-secure-repo
cd my-secure-repo
gcm setup
```

This performs:

1. Initialize git-crypt
2. Create .gitattributes with secure defaults
3. Commit setup + encrypted log entry

## Existing Repositories

Supported as long as the repository is clean:

```bash
git status  # must show nothing to commit
gcm setup
```

⚠️ Files already committed will remain plaintext in history Rewrite history manually if required.

## .gitattributes Rules

Created/updated automatically:

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

## Post-Setup

Now add users:

```bash
gcm add-users
```

Then push!

```bash
git remote add origin <url>
git push -u origin master
```
