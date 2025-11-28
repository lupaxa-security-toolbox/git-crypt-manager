# Key Generation

Quick key generation using gpg.

```bash
gpg --quick-generate-key "Your Name (git-crypt) <your.name@example.com>"  rsa4096 sign,cert,encrypt 2y
```

> The `encrypt` part is **ESSENTIAL** without that you will not be able to use the key with git-crypt.

Exporting your key

```bash
gpg --list-secret-keys --keyid-format=long
gpg --armor --export <ID>
```

Now simply share the `PUBLIC KEY` block with the maintainer of the repo and they can grant you access.
