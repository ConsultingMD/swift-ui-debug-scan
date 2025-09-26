# CI/CD Setup Documentation

This document explains the Continuous Integration and Continuous Deployment setup for the swift-ui-debug-scan project.

## Workflows

### 1. Main CI Workflow (`.github/workflows/ci.yml`)

**Triggers**: Pull requests and pushes to main branch
**Purpose**: Run tests and build validation across multiple platforms

**Test Matrix**:
- **macOS**: Tests on macOS 13 (Xcode 15.4/Swift 5.9) and macOS 14 (Xcode 16.1/Swift 6.0)
- **iOS Simulator**: iPhone 15 on iOS 17.5 and 18.1
- **tvOS Simulator**: Apple TV on tvOS 18.1
- **watchOS Simulator**: Apple Watch Series 10 on watchOS 11.1
- **visionOS Simulator**: Apple Vision Pro on visionOS 2.1

**Features**:
- Swift Package Manager caching for faster builds
- Code coverage collection (macOS only) with lcov export
- Parallel testing where supported
- Upload to Codecov for coverage reporting
- Verbose testing with `SWIFTUI_DEBUG_SCAN_VERBOSE=1`

### 2. Package Validation Workflow (`.github/workflows/ci.yml` - validate job)

**Purpose**: Validate Swift package structure and dependencies

**Checks**:
- Package.swift syntax validation
- Dependency resolution verification
- Dependency tree analysis

### 3. Release Workflow (`.github/workflows/release.yml`)

**Triggers**: Git tags (any tag pattern)
**Purpose**: Automated releases when tags are pushed

**Features**:
- Full validation (build + test) before release
- Source archive creation
- Release notes extraction from CHANGELOG.md
- GitHub release creation with artifacts
- Prerelease detection (alpha, beta, rc tags)

### 4. Security Workflows (`.github/workflows/security.yml`) - CURRENTLY DISABLED

**Status**: Commented out - requires Code Security/Code Scanning to be enabled
**Triggers**: PRs, main branch pushes, and weekly schedule (when enabled)
**Purpose**: Security scanning and vulnerability detection

**Features (when enabled)**:
- CodeQL static analysis for Swift code security
- Weekly automated security scans
- Integration with GitHub Security tab
- SARIF output format for security findings

**To enable**: Uncomment the workflow after enabling Code Scanning in repository settings

## Configuration Files

### Dependabot (`.github/dependabot.yml`)

**Purpose**: Automated dependency updates
**Features**:
- Weekly Swift package updates
- Weekly GitHub Actions updates  
- Proper labeling and commit message formatting
- Controlled PR limits

### Code Coverage (`codecov.yml`)

**Purpose**: Coverage reporting configuration
**Features**:
- Project coverage target: 80%
- Patch coverage target: 80% 
- Test files excluded from coverage
- Branch detection for conditionals and loops

## Key Features Inspired by member-ios-app

1. **Comprehensive Testing**: Native macOS Swift testing with code coverage
2. **Package Validation**: Swift package structure and dependency analysis
3. **Caching**: Aggressive SPM caching for performance
4. **Security**: CodeQL security scanning (currently disabled - enable Code Scanning in repo settings)
5. **Release Automation**: Comprehensive release process with artifacts

## Environment Variables Used

- `SWIFTUI_DEBUG_SCAN_VERBOSE`: Enables verbose test logging
- `GITHUB_TOKEN`: For GitHub API access (automatic)
- Various Codecov and security scanning tokens (configured via secrets)

## Differences from Private Repository Patterns

Since this is an open-source project, several adaptations were made:

1. **No Private Dependencies**: No access to private certificate repos or internal tools
2. **Simplified Release Process**: Using GitHub Releases instead of internal distribution
3. **Public Security Scanning**: Using GitHub's built-in security features
4. **Community Standards**: Following open-source contribution patterns

## Usage

### Running Tests Locally
```bash
swift test --verbose
SWIFTUI_DEBUG_SCAN_VERBOSE=1 swift test
```

### Building Release Version
```bash
swift build --configuration release
```

### Creating a Release
1. Update CHANGELOG.md with release notes
2. Create and push a git tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
3. GitHub Actions will automatically create the release

## Monitoring and Maintenance

- **CI Status**: Monitor via GitHub Actions tab
- **Coverage**: Check Codecov reports on PRs
- **Security**: Currently disabled (enable Code Scanning to activate)
- **Dependencies**: Dependabot will create PRs for updates