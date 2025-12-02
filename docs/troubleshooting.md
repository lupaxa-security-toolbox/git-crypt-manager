# Troubleshooting

## Repo is not clean

```bash
git add -A
git commit -m "Save before encryption"
```

or

```bash
git stash
```

## Key Not Trusted

```text
ERROR: GPG key is NOT trusted enough
```

Fix:

```bash
gpg --edit-key <KEYID>
trust
4
quit
```

Then rerun command.

## git-crypt not initialized

```bash
gcm setup
git add .gitattributes
git commit -m "Initialize git-crypt"
```

## Encrypted files unreadable

```bash
git-crypt unlock
```

## Missing .gitattributes rules

```bash
gcm setup
git add .gitattributes
git commit -m "Apply git-crypt attributes"
```
