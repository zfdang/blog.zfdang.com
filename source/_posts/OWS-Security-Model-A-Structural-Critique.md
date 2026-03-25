---
title: 'OWS Security Model: A Structural Critique'
date: 2026-03-25 17:41:11
tags:
---

# OWS Security Model: A Structural Critique

## Summary

The Open Wallet Standard (OWS) provides a well-documented local vault model for AI agent wallet access. However, a close reading of its storage format, policy engine, and key isolation specs reveals several structural security limitations that matter as agents move toward multi-machine, agent-as-a-service deployments.

### 1. Local-Only Trust Model in a Multi-Machine World

OWS trusts the local filesystem (`~/.ows/`) as its sole vault storage. All encrypted wallets, API key files, policies, and audit logs live on one machine.

But the reality of AI agents has already moved past single-machine deployments. Frameworks like OpenClaw run agents across distributed infrastructure. Agent-as-a-service is the clear trajectory. OWS's local vault assumption means it cannot natively serve agents running on different machines — let alone agents managed as hosted services by third-party providers.

### 2. Token-Based Authentication, Not Agent Identity

OWS authenticates agents via bearer tokens (`ows_key_<64 hex chars>`). There is no concept of verified agent identity — no code measurement, no attestation, no proof of what software is actually running.

The token is both the authentication credential and the decryption capability. Whoever holds the token *is* the agent, as far as OWS is concerned. This makes agent verification inherently weak: a leaked token gives full access with no way to distinguish the legitimate agent from an attacker.

### 3. No Isolation Between Same-User Processes

The root structural issue: all agents running under the same OS user share full filesystem access to `~/.ows/`. Unix file permissions (700/600) protect against *other users*, not against other processes owned by the same user.

This means any agent process can read, modify, or delete any file in the vault directory — including files belonging to other agents.

### 4. Policy Bypass via Direct Decryption

This is the most critical design implication. OWS's policy enforcement is a *code-path boundary*, not a *cryptographic boundary*.

If an agent has:
- its raw API token (`ows_key_...`)
- read access to `~/.ows/keys/<key-id>.json` (which any same-user process has)

Then it can implement the decryption itself:

```
HKDF-SHA256(token, salt, info="ows-api-key-v1", dklen=32) → AES key
AES-256-GCM(key, iv, ciphertext) → mnemonic or private_key
```

All required parameters — `salt`, `iv`, `auth_tag`, `ciphertext` — are stored in plaintext inside the key file's `wallet_secrets` map. The algorithms are standard. A few lines of code in any language is sufficient.

Policy checks (spending limits, chain restrictions, time windows) only run inside the OWS SDK's `sign()` call path. They do not alter the ciphertext's decryption conditions. An agent that bypasses the SDK bypasses all policies.

### 5. Cross-Agent Interference

Any agent can read, delete, or tamper with other agents' key files — even without their tokens. The effects:

| Action | Requires token? | Impact |
|--------|----------------|--------|
| Read another agent's key file | No | Exposes wallet IDs, policy IDs, encrypted secrets |
| Delete another agent's key file | No | Denial of service — that agent loses all wallet access |
| Tamper with another agent's key file | No | Corruption or sabotage |
| Decrypt another agent's wallet secrets | Yes | Full key extraction |

### 6. Policy Files Are Even More Exposed

Policy files have the weakest permissions in the entire vault:

```
~/.ows/policies/              drwxr-xr-x  (755)
~/.ows/policies/*.json        -rw-r--r--  (644)
```

OWS intentionally relaxes these because "policy files are not secret material." But this means a malicious agent can:

1. Read its own key file to find its `policy_ids`
2. Rewrite the referenced policy files — raise spending limits, expand allowed chains, remove time restrictions
3. Call `sign()` through the OWS SDK normally — the SDK loads the tampered policies from disk and evaluates them as legitimate

There is no integrity check (signature, hash binding) on policy files. The policy ID in the key file is a plain string reference resolved at runtime from the filesystem.

This is an even lower-barrier attack than direct decryption — it requires no cryptographic knowledge, no token manipulation, just writing a JSON file.

### The Fundamental Gap

These are not implementation bugs. They are structural consequences of OWS's trust model:

- Trust the local OS user as the security boundary
- Token-as-capability for agent access
- Policy-as-code-path, not policy-as-cryptographic-constraint
- No agent identity beyond bearer tokens

For single-user, single-machine, trusted-agent scenarios, this model is reasonable. For the emerging world of distributed, multi-provider, potentially adversarial agent ecosystems, these limitations become critical.


