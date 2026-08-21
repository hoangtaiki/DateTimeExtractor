# DateTimeExtractor

A standalone Swift package that extracts dates and times from free-form text strings (OCR output, receipts, natural language). Used as a dependency of ReceiptOCR.

## Commands

```bash
make lint      # SwiftLint (non-mutating)
make format    # SwiftFormat (mutates files in place)
make build     # swift build
make test      # swift test
```

## Architecture

Single `DateTimeExtractor` struct is the public entry point. It delegates to a `DateExtractable` (date format strategies) and the internal `TimeExtractor`, then groups adjacent date+time results via `groupDateAndTimeResults`.

| Type | Role |
|---|---|
| `DateExtractable` | Protocol; concrete implementations: `DateExtractor` (registered with `registerDefaultExtractors()`) which delegates to `DateDMYExtractor`, `DateMDYExtractor`, `DateYMDExtractor` |
| `TimeExtractor` | Internal; extracts 12h/24h times via regex |
| `ExtractedDateResult` / `ExtractedTimeResult` | Carry the matched string, `NSRange`, and format components |
| `DateFormatComponents` / `TimeFormatComponents` | Build format strings and normalised values for `DateFormatter` |

## Conventions

- **Adjacency tolerance:** date+time ranges separated by up to 3 characters (a comma + space) are treated as a combined datetime. Controlled by `DateTimeExtractor.maxAdjacencyGap`.
- **`.onlyTime` support:** times with no adjacent date are anchored to the current day (non-deterministic). Tests for this path assert on time-of-day components, not absolute `Date`.
- **Lint:** `blanket_disable_command` is disabled in `.swiftlint.yml` so data-heavy test fixture files can use file-scoped `// swiftlint:disable line_length`. Real source files use `// swiftlint:disable:next line_length` only on unwrappable regex literals.
