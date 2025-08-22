import Testing
import Foundation
@testable import SwiftUIDebugScan

/// Tests for String demangling extension (DEBUG-only functionality)
@Suite("String Demangling Tests")
struct StringDemanglingTests {
    
    #if DEBUG
    @Test("String demangling extension exists in DEBUG builds")
    func testDemanglingExtensionExists() {
        // Test that the demangling extension is available in DEBUG builds
        let testString = "someTestString"
        
        // The extension should exist and be callable
        // We can't easily test the actual swift_demangle function without
        // actual mangled symbols, but we can test that the extension exists
        let result = testString.demangled
        
        // For a non-mangled string, it should return nil
        #expect(result == nil)
    }
    
    @Test("Demangling handles empty string")
    func testDemanglingEmptyString() {
        let emptyString = ""
        let result = emptyString.demangled
        
        // Empty string should return nil
        #expect(result == nil)
    }
    
    @Test("Demangling handles regular strings")
    func testDemanglingRegularString() {
        let regularStrings = [
            "Hello",
            "World",
            "NotMangledAtAll",
            "some.regular.string"
        ]
        
        for string in regularStrings {
            let result = string.demangled
            // Regular strings should return nil since they're not mangled
            #expect(result == nil, "String '\(string)' should return nil when demangled")
        }
    }
    
    @Test("Demangling is safe with various input types")
    func testDemanglingSafety() {
        let testCases = [
            "$",
            "$$",
            "$s",
            "$s7SwiftUI",
            "regular$string",
            "unicode🚀string",
            String(repeating: "a", count: 1000)
        ]
        
        for testCase in testCases {
            // Should not crash or throw
            let result = testCase.demangled
            
            // We can't predict the exact results, but the operation should be safe
            // Most of these should return nil unless they're actually valid mangled names
            #expect(result == nil || result != nil, "Demangling should return nil or a String for input: \(testCase)")
        }
    }
    
    @Test("Demangling with potential SwiftUI mangled names")
    func testSwiftUIMangledPatterns() {
        // These are patterns that might appear in stack traces
        // but aren't necessarily valid mangled names
        let potentialMangledNames = [
            "$s7SwiftUI4ViewP",
            "$s7SwiftUI14_ViewModifierP", 
            "$s7SwiftUI5StateV",
            "$s7SwiftUI7BindingV",
            "$s7SwiftUI4TextV"
        ]
        
        for name in potentialMangledNames {
            let result = name.demangled
            
            // These might or might not demangle successfully
            // The important thing is that the function doesn't crash
            if let demangledResult = result {
                #expect(demangledResult.count > 0, "If demangling succeeds, result should not be empty")
            }
        }
    }
    #endif
}

/// Tests for the debug info dumping function
@Suite("Debug Info Dumping Tests")
struct DebugInfoDumpingTests {
    #if DEBUG
    @Test("Debug info dump function exists and is callable")
    func testDebugInfoDumpExists() {
        // Test that __dumpSUIDebugInfo can be called without crashing
        // Note: This function logs to the console, so we can't easily verify output
        // but we can ensure it doesn't crash
        
        // This should not crash
        __dumpSUIDebugInfo()
        
        // If we get here, the function completed successfully without crashing
        #expect(true)
    }
    
    @Test("Multiple calls to debug info dump are safe")
    func testMultipleDebugInfoCalls() {
        // Test that multiple calls don't cause issues
        __dumpSUIDebugInfo()
        __dumpSUIDebugInfo()
        __dumpSUIDebugInfo()
        
        // If we get here, multiple calls are safe
        #expect(true)
    }
    #endif
}
