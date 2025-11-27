# Setup Guide

Requirements:

- git
- gpg (GNUPG recommended)
- git-crypt installed

Verify:

```bash
git-crypt –version
gpg –list-secret-keys –keyid-format=long
```

If no GPG key exists:

```bash
gpg –default-new-key-algo rsa4096 –gen-key
```

Installing git-crypt-manager.sh:

```bash
chmod +x git-crypt-manager.sh
mv git-crypt-manager.sh /usr/local/bin/
```

Verify installation:

```bash
git-crypt-manager.sh –version
```

First-time secure repo setup:

```bash
git init secure-repo
cd secure-repo
git-crypt-manager.sh setup
git-crypt-manager.sh add-users
git add –renormalize .
git commit -m “Enable git-crypt encryption”
git push
```

User unlock workflow:

```bash
git clone
git-crypt unlock
```
