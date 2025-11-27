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

Installing git-crypt-manager:

```bash
git clone https://github.com/lupaxa-security-toolbox/git-crypt-manager
mv git-crypt-manager/src/git-crypt-manager /usr/local/bin/
```

Verify installation:

```bash
git-crypt-manager –version
```

First-time secure repo setup:

```bash
git init secure-repo
cd secure-repo
git-crypt-manager setup
git-crypt-manager add-users
git add –renormalize .
git commit -m “Enable git-crypt encryption”
git push
```

User unlock workflow:

```bash
git clone
git-crypt unlock
```
