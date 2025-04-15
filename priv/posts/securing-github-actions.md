---
title: Securing Your Github Actions
date: 2025-04-14 10:00
tags: security,article,en-US
---

# Securing Your Github Actions

GitHub Actions (GHA) has become a critical tool for Open Source projects aiming
to build reliable and customizable Continuous Integration (CI) and Continuous
Deployment/Delivery (CD) pipelines.

GHA is not just powerful—it's also a potential security vector if misused or
misconfigured. Below is a list of common vulnerabilities and practical
recommendations to secure your workflows.

### 1. Code Injection

Inputs like PR titles or issue comments can be manipulated to inject malicious code if not properly sanitized.

**Risky fields:**

- `event.issue.title`
- `event.issue.body`
- `event.pull_request.title`
- `event.pull_request.body`
- `event.review.body`
- `event.comment.body`

**Example:**
```yaml
- name: Check title
  run: |
    title="${{ github.event.issue.title }}"
    if [[ ! $title =~ ^.*:\ .*$ ]]; then
      echo "Bad issue title"
      exit 1
    fi
```

**Recommendation:**
Always treat these inputs as untrusted. Sanitize or validate all user-controlled data before use.

### 2. Environment Variables

Some environment variables can be abused to alter job behavior or exfiltrate data.

**Examples:**

- `NODE_OPTIONS` – disallowed by default
- `BASH_ENV` – can override subsequent runs
- `LD_PRELOAD` – allows loading attacker-controlled code
- `HTTPS_PROXY` – can redirect secrets to external hosts

**About `GITHUB_TOKEN`:**

- Short-lived and scoped per job
- Permissions vary by event trigger
- Stored on disk after checkout unless disabled

```yaml
- uses: actions/checkout@v4
  with:
    persist-credentials: false
```

**Recommendation:**

- Limit environment variable use to trusted inputs.
- Restrict `GITHUB_TOKEN` permissions to the minimum necessary.

### 3. `pull_request_target` Risks

The `pull_request_target` event exposes secrets and permissions to potentially untrusted code.

**Key risks:**

- Secrets are available, even from forks
- Subject to cache poisoning
- Vulnerable to TOCTOU (Time-of-Check Time-of-Use) attacks

**TOCTOU example:** A PR author can push new commits after a label is applied, bypassing safeguards.

**Recommendation:**

- Use `pull_request` + `workflow_run` with artifacts for forked PRs.
- Use `pull_request_target` **only** for trusted contributors.
- Always use `head_sha` when checking out code:

```yaml
- uses: actions/checkout@v4
  with:
    ref: ${{ github.event.pull_request.head.sha }}
```

### 4. TOCTOU on `pull_request.head.ref`

`pull_request.head.ref` is mutable and can be changed between job scheduling and execution.

**Recommendation:**

Use `pull_request.head.sha` instead, which represents a fixed commit.

### 5. `issue_comment` TOCTOU

Using issue comments for triggering commands can lead to race conditions and misuse.

**Recommendation:**

Prefer label-based triggers combined with `workflow_dispatch` or manual approvals for safer control.


### General Security Best Practices

- **Use short-lived and scoped `GITHUB_TOKEN`s.** They're available in memory during job execution, so follow the **principle of least privilege**.
- **Pin actions to commit SHAs** instead of tags. Tags are mutable and can be changed without notice.
- **Use CodeQL and GitHub Copilot** to catch vulnerabilities early—when used properly, they're powerful aids in securing your workflows.
- **Never trust artifacts blindly.** Validate them explicitly before use.

## Acknowledgments

Thanks to [Carlos Fuentes](https://github.com/metcoder95) for writting this article with me.
