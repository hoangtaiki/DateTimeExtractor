# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0]

Initial public release.

### Added
- Extract dates and times from free-form text (OCR output, receipts, natural language) via `DateTimeExtractor.extractDate(string:)`.
- Date format strategies: month-day-year (`DateMDYExtractor`), day-month-year (`DateDMYExtractor`), and year-month-day (`DateYMDExtractor`), registered through `DateExtractor.registerDefaultExtractors()`.
- Time extraction for 12-hour (`3:30 pm`) and 24-hour (`15:30`) formats, with optional seconds and am/pm.
- Adjacent date + time pairs are merged into a single `Date` (tolerance configurable via `maxAdjacencyGap`).
- `SupportedDateTimeType` options (`.bothDateAndTime`, `.onlyDate`, `.onlyTime`) to control which results are returned.
- Ambiguous `MM/DD` vs `DD/MM` resolution via `DateExtractor.prioritizedFormatType`.
- Extensibility: conform to `DateExtractable` and register custom strategies with `registerExtractor(_:)`.
- Opt-in `KoreanDotDateExtractor` for `YYYY.MM.DD` dotted dates.
- Calendar-aware patterns that reject impossible dates (e.g. `02/30`, Feb 29 in non-leap years).

### Performance
- Compiled `NSRegularExpression` objects are reused instead of recompiled per call.
- `DateFormatter` instances are cached by format string + timezone.

[Unreleased]: https://github.com/duchoangvp/DateTimeExtractor/compare/1.0.0...HEAD
[1.0.0]: https://github.com/duchoangvp/DateTimeExtractor/releases/tag/1.0.0
