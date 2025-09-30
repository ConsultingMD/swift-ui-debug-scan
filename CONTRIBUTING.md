# Contributing to swift-ui-debug-scan

Thank you for your interest in contributing to swift-ui-debug-scan! This document provides guidelines and information for contributors.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Environment](#development-environment)
- [Making Contributions](#making-contributions)
- [Testing](#testing)
- [Code Standards](#code-standards)
- [Pull Request Process](#pull-request-process)
- [Platform Support](#platform-support)

## Getting Started

### Prerequisites

- **Xcode**: Version 15.4+ (Swift 5.9+) or 16.1+ (Swift 6.0+)
- **macOS**: 13+ recommended for full platform testing
- **Swift**: 6.0+ (as specified in Package.swift)
- **Git**: For version control

### Cloning the Repository

```bash
git clone https://github.com/ConsultingMD/swift-ui-debug-scan.git
cd swift-ui-debug-scan
```

### Initial Setup

The project uses Swift Package Manager, so no additional setup is required beyond cloning.

```bash
# Verify the package builds correctly
swift build

# Run the test suite
swift test
```

## Development Environment

### IDE Recommendations

- **Xcode**: Primary development environment
- **VS Code**: With Swift extensions for lighter editing
- **Any editor**: That supports Swift syntax highlighting

### Package Structure

```
swift-ui-debug-scan/
├── Sources/
│   └── SwiftUIDebugScan/
│       └── DebugScan.swift          # Main implementation
├── Tests/
│   └── SwiftUIDebugScanTests/       # Test suite
├── Package.swift                    # Package definition
├── README.md                        # Project documentation
├── CHANGELOG.md                     # Release history
└── CI_SETUP.md                     # CI/CD documentation
```

## Making Contributions

### Types of Contributions

We welcome:

- **Bug fixes**: Resolving issues or unexpected behavior
- **Feature enhancements**: Improving existing functionality
- **New features**: Adding capabilities that align with the project's goals
- **Documentation improvements**: Enhancing clarity and completeness
- **Performance optimizations**: Making the library faster or more efficient
- **Test coverage**: Adding or improving tests

### Before You Start

1. **Check existing issues**: Look for related issues or discussions
2. **Open an issue**: For significant changes, discuss the approach first
3. **Fork the repository**: Create your own fork to work in
4. **Create a branch**: Use a descriptive name (`feature/improved-logging`, `fix/memory-leak`, etc.)

## Testing

### Running Tests

```bash
# Run all tests
swift test

# Run tests with verbose output
swift test --verbose

# Run tests with debug scan verbose mode
SWIFTUI_DEBUG_SCAN_VERBOSE=1 swift test

# Run tests for specific platform (if using Xcode)
xcodebuild test -scheme SwiftUIDebugScan -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Test Requirements

- **Code Coverage**: Maintain at least 80% test coverage (project target)
- **Platform Testing**: Ensure tests pass on all supported platforms:
  - iOS 15+
  - macOS 12+
  - tvOS 15+
  - watchOS 8+
  - visionOS 1+

### Writing Tests

- Place tests in the `Tests/SwiftUIDebugScanTests/` directory
- Follow existing naming conventions (`*Tests.swift`)
- Use descriptive test method names
- Test edge cases and error conditions

### Test Categories

Current test files cover:
- **FileParsingTests**: File path and module extraction
- **IntegrationTests**: End-to-end functionality
- **RenderStateTests**: State management and render counting
- **StringDemanglingTests**: Swift symbol demangling
- **ViewInspectorTests**: SwiftUI view testing with ViewInspector

## Code Standards

### Swift Style Guide

- **Swift 6**: Use modern Swift 6 features and syntax
- **Strict Concurrency**: Follow Swift 6 concurrency guidelines

### Specific Guidelines

#### Debug Mode Only Features
```swift
#if DEBUG
// Debug-only code here
#endif
```

## Pull Request Process

### Before Submitting

1. **Update documentation**: If you've changed functionality
2. **Add tests**: For new features or bug fixes
3. **Run the full test suite**: Ensure all tests pass
4. **Check code coverage**: Maintain or improve coverage
5. **Update CHANGELOG.md**: Add entry for your changes

### PR Requirements

- **Clear Title**: Descriptive and concise
- **Description**: Explain what changes were made and why
- **Issue Reference**: Link to related issues
- **Testing**: Describe how the changes were tested
- **Breaking Changes**: Clearly identify any breaking changes

### Review Process

1. **Automated Checks**: CI must pass (build, test, coverage)
2. **Code Review**: At least one maintainer review required
3. **Platform Testing**: Verify functionality across supported platforms
4. **Documentation**: Ensure documentation is updated if needed

### CI/CD Pipeline

The project uses GitHub Actions with comprehensive testing:

- **Build Validation**: Swift package builds successfully
- **Multi-Platform Testing**: iOS, macOS, tvOS, watchOS, visionOS
- **Code Coverage**: Codecov integration with 80% target
- **Package Validation**: Dependency resolution and structure checks

## Platform Support

### Supported Platforms

- **iOS**: 15.0+
- **macOS**: 12.0+
- **tvOS**: 15.0+
- **watchOS**: 8.0+
- **visionOS**: 1.0+

### Platform-Specific Considerations

- **Performance**: Consider platform limitations (watchOS memory, etc.)
- **API Availability**: Use appropriate availability checks
- **Testing**: Ensure functionality works across all platforms

## Getting Help

- **Issues**: Open a GitHub issue for bugs or feature requests
- **Discussions**: Use GitHub discussions for questions
- **Documentation**: Check README.md and CI_SETUP.md for additional information

## Code of Conduct

Please be respectful and professional in all interactions. We strive to maintain a welcoming and inclusive environment for all contributors.

## Recognition

Contributors are recognized in release notes and commit history. Significant contributions may be highlighted in the README or other project documentation.

---

Thank you for contributing to swift-ui-debug-scan! Your efforts help make SwiftUI debugging better for the entire Swift community.
