# Security Policy

## Supported Versions

This project packages MySQL Community Server LTS releases as Debian- and
Ubuntu-based Docker images. Only the current LTS lines receive updates
(including rebuilds that pick up base-image security patches):

| Version | Supported          |
| ------- | ------------------ |
| 9.7.x   | :white_check_mark: |
| 8.4.x   | :white_check_mark: |
| < 8.4   | :x:                |

Older MySQL series (e.g. 8.0) are End-of-Life upstream and are intentionally
not maintained here.

## Scope

This repository only contains **packaging** — Dockerfiles, the entrypoint
script, CI workflows, and configuration. Please report issues that concern
this packaging, for example:

- A vulnerability introduced by how the image is built (e.g. a misconfigured
  permission, an exposed secret, an insecure default in `docker-entrypoint.sh`).
- A compromised or incorrect dependency pinned by this repository.
- A problem in the GitHub Actions workflows.

Vulnerabilities in **MySQL itself** are out of scope here and should be
reported to Oracle through the
[MySQL security process](https://www.oracle.com/security-alerts/). The same
applies to vulnerabilities in the base image, which belong to the
[Debian security team](https://www.debian.org/security/) or
[Ubuntu security](https://ubuntu.com/security) respectively.

## Reporting a Vulnerability

Please **do not** open a public issue for security problems.

Use GitHub's private reporting instead:
**Security → Report a vulnerability** (Private Vulnerability Reporting) on this
repository.

What to expect:

- An initial acknowledgement within about **7 days**.
- If accepted, a fix or mitigation will be prepared and a new image published;
  the advisory will be made public once a fix is available.
- If declined (e.g. out of scope, or a duplicate of an upstream MySQL/Debian
  issue), you will receive an explanation and, where possible, a pointer to the
  correct place to report it.

As this is a small unofficial fork maintained on a best-effort basis, response
times may vary.
