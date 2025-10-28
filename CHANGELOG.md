# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2025-10-28
### Added
- Comprehensive test suite with 800+ lines of test code
  - `FileParsingTests.swift` for file parsing functionality testing
  - `IntegrationTests.swift` for end-to-end integration testing
  - `RenderStateTests.swift` for render state tracking verification
  - `StringDemanglingTests.swift` for Swift symbol demangling validation
  - `ViewInspectorTests.swift` for SwiftUI view testing using ViewInspector framework
- Project governance and documentation
  - MIT `LICENSE` file
  - `CODE_OF_CONDUCT.md` for community guidelines
  - `CONTRIBUTING.md` with detailed contribution guidelines and development setup
- ViewInspector dependency (0.10.3) for enhanced SwiftUI testing capabilities

### Changed
- Improved README documentation with better formatting and clearer examples
- Enhanced console output examples and debugScan usage demonstrations
- Streamlined package configuration by removing library evolution setting

### Updated
- ViewInspector dependency from 0.10.2 to 0.10.3
- GitHub Actions checkout action from v4 to v5
- CodeCov action from v4 to v5

### Removed
- Unused security workflow and CI setup documentation files

### Fixed
- Failing integration test on CI environment
- Various README content corrections and improvements

## [0.1.0] - 2025-07-22
### Added
- Initial release of `SwiftUIDebugScan`.
- Introduced the `debugScan` view modifier for logging and tracking SwiftUI view rendering.
- Added support for verbose logging via the `SWIFTUI_DEBUG_SCAN_VERBOSE` environment variable.
- Included `RenderState` actor for tracking render counts.
