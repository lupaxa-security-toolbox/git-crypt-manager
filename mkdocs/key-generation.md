# 🔑 GPG Key Generation & Trust Requirements

GCM enforces strong identity verification:

- Only **trusted** keys allowed
- Unknown or marginal trust keys rejected

## Generating a Key

```bash
gpg --quick-generate-key "Your Name (git-crypt) <your.name@example.com>"  rsa4096 sign,cert,encrypt 2y
```

> The `encrypt` part is **ESSENTIAL** without that you will not be able to use the key with git-crypt.

## Exporting your key

```bash
gpg --list-secret-keys --keyid-format=long
gpg --armor --export <ID> > mykey.asc
```

This file is safe to share with collaborators.

## Importing a Public Key

```bash
gpg --import mykey.asc
```

### Setting Full Trust

```bash
gpg --edit-key <KEYID>
trust
# choose option 4 = full trust
quit
```

> Required before gcm add-users.

## Find Key Information

List public keys:

```bash
gpg --list-keys
```

Get fingerprint:

```bash
gpg --fingerprint <KEYID>
```
