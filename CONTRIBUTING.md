# Contributing to DateTimeExtractor

Thanks for your interest in improving DateTimeExtractor. Contributions of all kinds are welcome - bug reports, new format strategies, tests, and documentation.

## Getting started

The package is pure Swift and depends only on `Foundation` - no external dependencies, no code generation.

```bash
git clone https://github.com/duchoangvp/DateTimeExtractor.git
cd DateTimeExtractor
make build
make test
```

You need [SwiftLint](https://github.com/realm/SwiftLint) and [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) for the lint/format targets:

```bash
brew install swiftlint swiftformat
```

## Development commands

| Command | Purpose |
|---|---|
| `make build` | `swift build` |
| `make test` | `swift test` (56+ tests) |
| `make lint` | SwiftLint - must report 0 violations |
| `make format` | SwiftFormat - mutates files in place |

`.swiftlint.yml` and `.swiftformat` are intentionally aligned so the two tools do not fight. Run `make format` before `make lint`.

## Architecture

`DateTimeExtractor` runs a three-pass pipeline: extract dates and times separately, group adjacent date+time pairs, then convert to `Date`. See [README.md](README.md#architecture) for the type breakdown.

### Adding a new date format strategy

1. Create a type conforming to `DateExtractable` (see `DateMDYExtractor` / `DateYMDExtractor` for reference).
2. Return `ExtractedDateResult` values carrying the matched string, its `NSRange`, and `DateFormatComponents`.
3. Reuse the protocol helpers `extractStringWithRegex(string:regex:)` and `detectDateSeparator(string:)`.
4. Register it - either add it to `DateExtractor.registerDefaultExtractors()` (if it should be on by default) or leave it opt-in like `KoreanDotDateExtractor`.
5. Add tests covering valid matches, the boundary/invalid cases, and any leap-year edge cases.

## Pull request checklist

Before opening a PR, make sure:

- [ ] `make test` passes.
- [ ] `make lint` reports 0 violations.
- [ ] New or changed behaviour is covered by tests.
- [ ] New public API has a doc comment.
- [ ] User-facing changes are noted under `## [Unreleased]` in [CHANGELOG.md](CHANGELOG.md).

Keep PRs focused - one logical change per pull request makes review faster.

## Reporting bugs

Open an issue using the bug report template. Include the exact input string, the `Date`(s) you got, and the `Date`(s) you expected - that makes reproduction trivial.
