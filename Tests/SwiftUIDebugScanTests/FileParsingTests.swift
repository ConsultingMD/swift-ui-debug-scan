import Testing
import Foundation
@testable import SwiftUIDebugScan

/// Tests for environment variable parsing behavior
@Suite("File Parsing Tests")
struct FileParsingTests {

    @Test("ViewInstrumentationModifier fileForDisplay behavior")
    @MainActor func testFileForDisplayVerbose() {
        let modifier = ViewInstrumentationModifier(
            label: "TestLabel",
            file: "/path/to/TestFile.swift",
            fileID: "TestModule/TestFile.swift",
            filePath: "/full/path/to/TestFile.swift"
        )

        #expect(modifier.file == "TestFile.swift")
        #expect(modifier.filePath == "/full/path/to/TestFile.swift")
        #expect(modifier.module == "TestModule")
        #expect(modifier.label == "TestLabel")
    }
    
    @Test("ViewInstrumentationModifier handles file path components correctly")
    @MainActor func testFilePathComponents() {
        let modifier = ViewInstrumentationModifier(
            label: "Test",
            file: "/very/long/path/to/some/nested/File.swift",
            fileID: "MyModule/Submodule/File.swift", 
            filePath: "/absolute/path/File.swift"
        )
        
        #expect(modifier.file == "File.swift")
        #expect(modifier.module == "MyModule")
    }
    
    @Test("ViewInstrumentationModifier handles edge cases in file paths")
    @MainActor func testFilePathEdgeCases() {
        let modifier1 = ViewInstrumentationModifier(
            label: "Test",
            file: "SimpleFile.swift",
            fileID: "SimpleModule",
            filePath: "SimpleFile.swift"
        )
        
        #expect(modifier1.file == "SimpleFile.swift")
        #expect(modifier1.module == "SimpleModule")
        
        let modifier2 = ViewInstrumentationModifier(
            label: "Test",
            file: "",
            fileID: "",
            filePath: ""
        )
        
        #expect(modifier2.file == "")
        #expect(modifier2.module == "")
    }
    
    @Test("ViewInstrumentationModifier handles trailing slashes gracefully")
    @MainActor func testTrailingSlashes() {
        let modifier = ViewInstrumentationModifier(
            label: "Test",
            file: "/path/to/file/",
            fileID: "Module/Submodule/",
            filePath: "/path/"
        )
        
        #expect(modifier.file == "")
        #expect(modifier.module == "Module")
    }
}
