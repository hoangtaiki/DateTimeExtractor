# DateTimeExtractor

[![CI](https://github.com/duchoangvp/DateTimeExtractor/actions/workflows/ci.yml/badge.svg)](https://github.com/duchoangvp/DateTimeExtractor/actions/workflows/ci.yml)
[![Swift Version Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fduchoangvp%2FDateTimeExtractor%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/duchoangvp/DateTimeExtractor)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fduchoangvp%2FDateTimeExtractor%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/duchoangvp/DateTimeExtractor)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A dependency-free Swift package that extracts dates and times from free-form text - OCR output, receipts, and natural-language strings. Given a string, it returns an array of `Date` values for every date/time it recognises.

It is regex-based (no NLP, no network) so it runs fully on-device and is safe for privacy-sensitive input.

## Requirements

- Swift 5.7.1+
- Any Apple platform (uses only `Foundation`)

## Installation

Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/duchoangvp/DateTimeExtractor.git", from: "1.0.0")
]
```

Then add `"DateTimeExtractor"` to your target's dependencies.

In Xcode: **File → Add Package Dependencies…** and enter `https://github.com/duchoangvp/DateTimeExtractor.git`.

## Usage

```swift
import DateTimeExtractor

// 1. Build a date extractor and register the default format strategies.
var dateExtractor = DateExtractor()
dateExtractor.registerDefaultExtractors()

// 2. Create the top-level extractor.
let extractor = DateTimeExtractor(dateExtractor: dateExtractor)

// 3. Extract.
let dates = extractor.extractDate(string: "Paid at Starbucks on 12/25/2024 3:30 pm")
// -> [2024-12-25 15:30:00]
```

### Configuration

`DateTimeExtractor.init` takes two optional arguments:

```swift
let extractor = DateTimeExtractor(
    dateExtractor: dateExtractor,
    supportedDateTimeTypes: [.bothDateAndTime, .onlyDate], // default
    timezone: .current                                      // default
)
```

`supportedDateTimeTypes` controls which results are returned:

| Type | Meaning |
|---|---|
| `.bothDateAndTime` | A date and a time that sit next to each other are merged into one `Date`. |
| `.onlyDate` | Dates with no adjacent time are returned (time defaults to midnight). |
| `.onlyTime` | Times with no adjacent date are anchored to **today**. Non-deterministic - depends on the current day. Opt-in; not in the default set. |

### Ambiguous formats (MDY vs DMY)

`10/11/2024` is valid as both October 11 and November 10. When two strategies match the same range, `DateExtractor` keeps the one matching its `prioritizedFormatType` (default `.MDY`):

```swift
var dateExtractor = DateExtractor(prioritizedFormatType: .DMY)
dateExtractor.registerDefaultExtractors()
// now 10/11/2024 -> 10 November 2024
```

## Supported formats

Registered by `registerDefaultExtractors()`:

- **MDY** - `12-25-24`, `12/25/2024`, `Dec 25 2024`, `December 25, 2024`, `Dec 25' 24` (separators `/ - .`, case-insensitive month names)
- **DMY** - `25-12-24`, `25/12/2024`, `25 Dec 2024`, `25 December 2024`
- **YMD** - `2024-12-25` (dash-separated only)
- **Time** - 12-hour `3:30 pm`, `3:30:15 pm`, `3p`; 24-hour `15:30`, `15:30:15` (optional seconds, optional am/pm)

The patterns are calendar-aware: they reject impossible dates like `02/30/2024` or Feb 29 in a non-leap year.

### Opt-in extractors

`KoreanDotDateExtractor` matches `YYYY.MM.DD` (dot-separated, common on Korean receipts). It is not registered by default:

```swift
dateExtractor.registerExtractor(KoreanDotDateExtractor())
```

## Extending

Conform to `DateExtractable` to add a custom format strategy, then register it:

```swift
struct MyExtractor: DateExtractable {
    func extractDateStringAndFormat(string: String) -> [ExtractedDateResult] {
        // return matches with their NSRange + DateFormatComponents
    }
}

dateExtractor.registerExtractor(MyExtractor())
```

The `DateExtractable` protocol extension provides `extractStringWithRegex(string:regex:)` and `detectDateSeparator(string:)` helpers.

## Architecture

`DateTimeExtractor` runs a three-pass pipeline: extract dates and times separately, group adjacent date+time pairs (tolerance controlled by `maxAdjacencyGap`, default 3 characters so `", "` still merges), then convert to `Date` via `DateFormatter`.

| Type | Role |
|---|---|
| `DateTimeExtractor` | Public entry point; orchestrates the pipeline. |
| `DateExtractor` | Default `DateExtractable`; fans out to the MDY/DMY/YMD strategies and resolves range collisions by priority. |
| `DateExtractable` | Protocol for date format strategies. |
| `TimeExtractor` | Internal; extracts 12h/24h times. |
| `ExtractedDateResult` / `ExtractedTimeResult` | Carry the matched string, `NSRange`, and format components. |

### Performance

Compiled `NSRegularExpression` objects are cached (per `DateRegex` / per extractor type), and `DateFormatter` instances are reused via an internal cache keyed on format + timezone - both are expensive to create, so nothing is recompiled or reallocated across calls.

## Development

```bash
make build     # swift build
make test      # swift test
make lint      # SwiftLint (non-mutating)
make format    # SwiftFormat (mutates in place)
```

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the build/test/lint workflow and how to add a new format strategy. By participating you agree to the [Code of Conduct](CODE_OF_CONDUCT.md).

## License

DateTimeExtractor is available under the MIT License. See [LICENSE](LICENSE) for details.
