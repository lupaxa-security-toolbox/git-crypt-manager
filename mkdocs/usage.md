# 🚀 Usage Guide

Run help for quick usage:

```bash
gcm help
```

## Commands

| Command          | Description                              |
| :--------------- | :--------------------------------------- |
| gcm setup        | Initialize encryption rules.             |
| gcm add-users    | Add trusted GPG collaborators.           |
| gcm list-users   | Show currently authorized users.         |
| gcm rotate-users | Replace GPG key for a user.              |
| gcm revoke-users | Remove access from users.                |
| gcm destroy      | Remove git-crypt encryption (dangerous). |

## Adding Users

```bash
gcm add-users
```

You will be prompted:

- number of users
- GPG Key IDs (email / fingerprint / short ID)
- key trust is verified automatically

Example:

```bash
GPG key identifier for user 1: 1234567890ABCDEF
[OK] Added GPG user: Alice Jones <alice@example.com>
```

## Listing Users

```bash
gcm list-users
```

Output:

```bash
Current git-crypt users:
 - Alice <alice@example.com> (1234567890ABCDEF)
 - Bob <bob@example.com> (FEDCBA0987654321)
```

## Rotating Keys

Used when a user generates a new key:

```bash
gcm rotate-users
```

## Revoking Users

```bash
gcm revoke-users
```

When needed:

- Employee leaves the company
- Third-party contract ends
- Compromised key must be removed

## Destroy Encryption

Removes all git-crypt functionality:

```bash
gcm unencrypt
```

⚠️ This cannot be undone without re-encrypting data
