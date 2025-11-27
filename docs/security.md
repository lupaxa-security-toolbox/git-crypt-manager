# Security Model

Encryption:

- Everything encrypted by default
- Except:

```bash
    README.md
    .md
    docs/*
    .github/**
    .gitignore
```

- Audit logs (.git-crypt-logs/**) are encrypted

Trust model for GPG keys:

- Full or ultimate trust recommended
- Low trust (marginal/unknown) triggers warning + confirmation

Promoting trust manually:

```bash
gpg –edit-key
trust
select full
quit
```

Audit logging:

- All operations logged in JSON
- Logs committed and encrypted
- Provides tamper-evident history

Leak detection:

- Detects high-risk plaintext content
- Protects against accidental token or key exposure
