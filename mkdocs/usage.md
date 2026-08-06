# Usage Guide

Run help for quick usage:

```bash
gcm help
```

## Commands

| Command           | Description                                      |
| :---------------- | :----------------------------------------------- |
| gcm setup         | Initialise encryption rules (clean repo only).   |
| gcm add-users     | Add trusted GPG collaborators.                   |
| gcm list-users    | Show currently authorised users.                 |
| gcm rotate-user   | Replace a collaborator's GPG key.                |
| gcm revoke-user   | Remove access from users.                        |
| gcm doctor        | Read-only diagnostics.                           |
| gcm backup        | Backup `.git-crypt` and `.gitattributes`.        |
| gcm restore       | Restore the latest local backup.                 |
| gcm nuclear-rotate| Regenerate the encryption key (dangerous).       |
| gcm unencrypt     | Remove git-crypt rules for future commits.       |

## Adding Users

Interactive (same as before):

```bash
gcm add-users
```

You will be prompted for:

- number of users
- GPG key identifiers (email / fingerprint / key ID)
- key trust is verified automatically (`full` or `ultimate`)

Or pass keys on the command line:

```bash
gcm add-users alice@example.com bob@example.com
```

Example interactive output:

```bash
GPG key identifier for user 1: 1234567890ABCDEF
[OK] Added GPG user: Alice Jones <alice@example.com>
```

## Listing Users

```bash
gcm list-users
```

## Rotating Keys

Used when a user generates a new key. The new key is added first, then the old
key is revoked (so a failed add does not leave the user locked out).

Interactive:

```bash
gcm rotate-user
```

Or with arguments:

```bash
gcm rotate-user old@example.com new@example.com
```

## Revoking Users

```bash
gcm revoke-user
```

Or:

```bash
gcm revoke-user alice@example.com
```

When needed:

- Employee leaves the company
- Third-party contract ends
- Compromised key must be removed

## Remove Encryption Going Forward

Removes the auto-generated git-crypt `.gitattributes` rules:

```bash
gcm unencrypt
```

This does not decrypt historical commits. Existing ciphertext stays encrypted.
