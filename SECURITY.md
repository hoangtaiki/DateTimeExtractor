# Security Policy

## Supported Versions

Security fixes are applied to the latest minor release.

| Version | Supported |
|---------|-----------|
| 1.x     | ✅        |

## Reporting a Vulnerability

DateTimeExtractor is an offline, dependency-free text-parsing library with a
small attack surface - it performs no networking, file, or process access. Even
so, if you believe you have found a security issue (for example, a regular
expression that can be driven into catastrophic backtracking on crafted input),
please report it privately.

**Do not open a public issue for security reports.**

Instead, either:

- Use GitHub's [private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)
  ("Report a vulnerability" under the repository's **Security** tab), or
- Email **duchoang.vp@gmail.com** with a description and a minimal reproducing input string.

You can expect an acknowledgement within a few business days. Once a fix is
released, we are happy to credit reporters who wish to be named.
