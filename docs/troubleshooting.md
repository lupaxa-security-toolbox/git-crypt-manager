# Troubleshooting

Problem: Encrypted files unreadable

```bash
git-crypt unlock
```

Problem: git-crypt not initialized

```bash
git-crypt-manager setup
git add .gitattributes
git commit -m “Initialize git-crypt”
```

Problem: Missing .gitattributes rules

```bash
git-crypt-manager setup
git add .gitattributes
git commit -m “Apply git-crypt attributes”
```

Problem: GPG trust warnings

```bash
gpg –edit-key
trust
set trust level to full/ultimate
```
