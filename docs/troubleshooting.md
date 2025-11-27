# Troubleshooting

Problem: Encrypted files unreadable
Fix:

```bash
git-crypt unlock
```

Problem: git-crypt not initialized
Fix:

```bash
git-crypt-manager setup
git add .gitattributes
git commit -m “Initialize git-crypt”
```

Problem: Missing .gitattributes rules
Fix:

```bash
git-crypt-manager setup
git add .gitattributes
git commit -m “Apply git-crypt attributes”
```

Problem: Leak scan failed
Fix:

```bash
Check listed files for secrets
Remove or replace secret content
Rotate exposed credentials
Commit and re-scan:
git-crypt-manager doctor –leaks
```

Problem: GPG trust warnings
Fix:

```bash
gpg –edit-key
trust
set trust level to full/ultimate
```
