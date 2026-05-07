# Changelog

All notable changes to this action are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.1] - 2026-05-07

### Added

- Self-explanatory output: each run now prints a one-time intro describing what triple-base64 is, why it bypasses the GitHub Actions log masker, and how to recover a secret locally.
- Per-secret group now includes `name:`, `encoded:`, `value:`, and a paste-ready `decode:` one-liner.
- `release` recipe in the `Justfile` that creates a `vX.Y.Z` annotated tag and re-points the matching `vX` major pointer in one step, then prints the `git push` commands.

## [1.0.0] - 2026-05-07

### Added

- Initial release.
- Composite action with two inputs: `secret` (single value) and `secrets` (multiline `NAME=VALUE` list).
- Each secret is base64-encoded three times so it bypasses the GitHub Actions log masker, with intermediate newlines stripped to keep the output blob compact.
- Each output group includes a `decode:` one-liner that recovers the original value via three `base64 -d` invocations.
- `tag` recipe in the `Justfile` for creating `v`-prefixed annotated tags.

[Unreleased]: https://github.com/begoon/ghasecret/compare/v1.0.1...HEAD
[1.0.1]: https://github.com/begoon/ghasecret/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/begoon/ghasecret/releases/tag/v1.0.0
