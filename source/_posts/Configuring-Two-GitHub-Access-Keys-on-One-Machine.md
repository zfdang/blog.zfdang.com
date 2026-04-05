---
title: Configuring Two GitHub Access Keys on One Machine
date: 2026-04-05 08:28:52
tags:
---

# Configuring Two GitHub Access Keys on One Machine

This guide shows how to configure **two GitHub accounts on the same machine** using **two SSH keys** and an SSH config file:

- one for your **personal account**
- one for your **organization/work account**

This is the most reliable setup when the two accounts access different repositories.

---

## Overview

The recommended approach is:

1. Generate **one SSH key per GitHub account**
2. Add both keys to `ssh-agent`
3. Configure `~/.ssh/config` with **two host aliases**
4. Use the correct alias in each repository's remote URL
5. Optionally set different Git commit identities per repository

---

## 1. Generate Two SSH Keys

Create one key for your personal GitHub account and one for your organization account.

```bash
ssh-keygen -t ed25519 -C "your_personal_email@example.com"
# Save as: ~/.ssh/id_ed25519_github_personal

ssh-keygen -t ed25519 -C "your_work_email@example.com"
# Save as: ~/.ssh/id_ed25519_github_work
```

After that, upload the public keys to the correct GitHub accounts:

- `~/.ssh/id_ed25519_github_personal.pub` -> personal GitHub account
- `~/.ssh/id_ed25519_github_work.pub` -> organization/work GitHub account

---

## 2. Add Both Keys to ssh-agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_github_personal
ssh-add ~/.ssh/id_ed25519_github_work
```

This allows SSH to manage both keys more conveniently.

---

## 3. Configure `~/.ssh/config`

Edit your SSH config file:

```sshconfig
Host github-personal
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github_personal
  IdentitiesOnly yes

Host github-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github_work
  IdentitiesOnly yes
```

### Why this works

- `github-personal` and `github-work` are **local SSH aliases**
- both point to `github.com`
- each alias forces SSH to use a specific private key
- `IdentitiesOnly yes` prevents SSH from using the wrong key from `ssh-agent`

---

## 4. Test Each Account

Run:

```bash
ssh -T git@github-personal
ssh -T git@github-work
```

If everything is configured correctly, GitHub should confirm authentication for each account.

---

## 5. Clone Repositories with the Correct Alias

### Personal repository

```bash
git clone git@github-personal:yourname/my-repo.git
```

### Organization repository

```bash
git clone git@github-work:your-org/team-repo.git
```

> Important: do **not** use `git@github.com:...` if you want SSH to choose between accounts automatically.  
> Use the host aliases defined in `~/.ssh/config`.

---

## 6. Update Existing Repository Remotes

If you already cloned a repository, change its remote URL.

### Personal repository

```bash
git remote set-url origin git@github-personal:yourname/my-repo.git
```

### Organization repository

```bash
git remote set-url origin git@github-work:your-org/team-repo.git
```

---

## 7. Optional: Set Different Git Commit Identities

SSH authentication and Git commit identity are different things.

If you also want commits to show different names or emails, configure them per repository.

### In a personal repository

```bash
git config user.name "Your Personal Name"
git config user.email "your_personal_email@example.com"
```

### In a work repository

```bash
git config user.name "Your Work Name"
git config user.email "your_work_email@example.com"
```

---

## 8. Troubleshooting

If Git still uses the wrong account, run SSH in verbose mode:

```bash
ssh -vT git@github-work
```

Check the output to confirm which `IdentityFile` is being used.

---

## Recommended Best Practice

For long-term maintenance, use:

- **one SSH key per GitHub account**
- **SSH host aliases** in `~/.ssh/config`
- **repository-specific remote URLs**
- **repository-specific Git user.name and user.email** if needed

This setup is simple, stable, and works well when personal and organization accounts access different repositories.
