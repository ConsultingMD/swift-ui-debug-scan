import Testing
import SwiftUI
import Foundation
@testable import SwiftUIDebugScan

/// Integration tests that verify the overall behavior of the SwiftUIDebugScan library
@Suite("Integration Tests")
struct IntegrationTests {
    
    @Test("Complete debugScan workflow")
    @MainActor func testCompleteDebugScanWorkflow() async {
        let originalView = VStack {
            Text("Hello")
            Text("World")
        }
        let modifiedView = originalView.debugScan("IntegrationTest")
        
        let originalTypeName = String(describing: type(of: originalView))
        let modifiedTypeName = String(describing: type(of: modifiedView))
        
        #expect(originalTypeName != modifiedTypeName, "debugScan should change the view type")
        #expect(modifiedTypeName.contains("ModifiedContent"), "debugScan should wrap view in ModifiedContent")
        
        let expectedModifier = ViewInstrumentationModifier(
            label: "IntegrationTest", 
            file: #file,
            fileID: #fileID, 
            filePath: #filePath
        )
        #expect(expectedModifier.label == "IntegrationTest")
        #expect(expectedModifier.file.hasSuffix("IntegrationTests.swift"))
    }
    
    @Test("Multiple debugScan modifiers on same view")
    @MainActor func testMultipleDebugScanModifiers() {
        let baseView = Text("Test")
        let step1 = baseView.debugScan("First")
        let step2 = step1.padding().debugScan("Second") 
        let finalView = step2.background(Color.blue).debugScan("Third")
        
        let type1 = String(describing: type(of: step1))
        let type2 = String(describing: type(of: step2))
        let type3 = String(describing: type(of: finalView))
        
        #expect(type1.contains("ModifiedContent"))
        #expect(type2.contains("ModifiedContent")) 
        #expect(type3.contains("ModifiedContent"))
        
        #expect(type1 != type2, "Each debugScan should create different types")
        #expect(type2 != type3, "Each debugScan should create different types")
        
        let mod1 = ViewInstrumentationModifier(label: "First", file: #file, fileID: #fileID, filePath: #filePath)
        let mod2 = ViewInstrumentationModifier(label: "Second", file: #file, fileID: #fileID, filePath: #filePath)
        let mod3 = ViewInstrumentationModifier(label: "Third", file: #file, fileID: #fileID, filePath: #filePath)
        
        #expect(mod1.label == "First")
        #expect(mod2.label == "Second")
        #expect(mod3.label == "Third")
    }
    
    @Test("debugScan with complex view hierarchies")
    @MainActor func testComplexViewHierarchy() {
        let leftText = Text("Left").debugScan("LeftText")
        let rightText = Text("Right").debugScan("RightText")
        
        let hstack = HStack {
            leftText
            Spacer()
            rightText
        }.debugScan("HStack")
        
        let scrollContent = ScrollView {
            LazyVStack {
                ForEach(0..<10, id: \.self) { index in
                    Text("Item \(index)")
                        .debugScan("Item\(index)")
                }
            }
            .debugScan("LazyVStack")
        }
        .debugScan("ScrollView")
        
        let complexView = VStack {
            hstack
            Divider()
            scrollContent
        }
        .debugScan("MainVStack")
        
        let leftTextType = String(describing: type(of: leftText))
        let hstackType = String(describing: type(of: hstack))
        let scrollType = String(describing: type(of: scrollContent))
        let mainType = String(describing: type(of: complexView))
        
        for typeName in [leftTextType, hstackType, scrollType, mainType] {
            #expect(typeName.contains("ModifiedContent"), "Type \(typeName) should contain ModifiedContent")
        }
        
        let expectedLabels = ["LeftText", "RightText", "HStack", "LazyVStack", "ScrollView", "MainVStack"]
        for label in expectedLabels {
            let testModifier = ViewInstrumentationModifier(
                label: label, 
                file: #file, 
                fileID: #fileID, 
                filePath: #filePath
            )
            #expect(testModifier.label == label, "Label \(label) should be preserved correctly")
        }
    }
    
    @Test("debugScan with conditional views")
    @MainActor func testConditionalViews() {
        let testBothBranches = { (showText: Bool) -> String in
            let conditionalView = Group {
                if showText {
                    Text("Visible")
                        .debugScan("ConditionalText")
                } else {
                    EmptyView()
                        .debugScan("EmptyView")
                }
            }
            .debugScan("ConditionalGroup")
            
            return String(describing: type(of: conditionalView))
        }
        
        let trueType = testBothBranches(true)
        let falseType = testBothBranches(false)
        
        #expect(trueType.contains("ModifiedContent"))
        #expect(falseType.contains("ModifiedContent"))
        
        #expect(trueType == falseType, "Conditional content shouldn't affect outer modifier type")
        
        let visibleModifier = ViewInstrumentationModifier(
            label: "ConditionalText", 
            file: #file, 
            fileID: #fileID, 
            filePath: #filePath
        )
        let emptyModifier = ViewInstrumentationModifier(
            label: "EmptyView", 
            file: #file, 
            fileID: #fileID, 
            filePath: #filePath
        )
        let groupModifier = ViewInstrumentationModifier(
            label: "ConditionalGroup", 
            file: #file, 
            fileID: #fileID, 
            filePath: #filePath
        )
        
        #expect(visibleModifier.label == "ConditionalText")
        #expect(emptyModifier.label == "EmptyView")
        #expect(groupModifier.label == "ConditionalGroup")
    }
    
    @Test("RenderState actor in realistic usage")
    func testRenderStateRealisticUsage() async {
        let renderStates = (0..<5).map { _ in RenderState() }
        
        let renderTasks = renderStates.map { state in
            Task {
                var counts: [Int] = []
                for _ in 0..<3 {
                    let count = await state.record()
                    counts.append(count)
                }
                return counts
            }
        }
        
        let results = await withTaskGroup(of: [Int].self) { group in
            for task in renderTasks {
                group.addTask { await task.value }
            }
            
            var allResults: [[Int]] = []
            for await result in group {
                allResults.append(result)
            }
            return allResults
        }
        
        for result in results {
            #expect(result == [1, 2, 3])
        }
    }
    
    @Test("Performance characteristics of debugScan")
    @MainActor func testDebugScanPerformance() async {
        let testSizes = [10, 50, 100]
        var results: [(size: Int, duration: Double)] = []
        
        for size in testSizes {
            let startTime = CFAbsoluteTimeGetCurrent()
            
            let views = (0..<size).map { index in
                Text("Performance test \(index)")
                    .debugScan("PerformanceTest\(index)")
            }
            
            let endTime = CFAbsoluteTimeGetCurrent()
            let duration = endTime - startTime
            results.append((size: size, duration: duration))
            
            #expect(views.count == size)
            
            let firstViewType = String(describing: type(of: views[0]))
            let lastViewType = String(describing: type(of: views[size-1]))
            #expect(firstViewType.contains("ModifiedContent"))
            #expect(lastViewType.contains("ModifiedContent"))
            
            // Performance should scale reasonably (< 10ms per view for creation)
            let avgTimePerView = duration / Double(size)
            #expect(avgTimePerView < 0.01, "Creating debugScan views took \(avgTimePerView*1000)ms per view, expected < 10ms")
        }
        
        // Test that performance scales roughly linearly (not exponentially)
        let time10 = results[0].duration
        let time100 = results[2].duration
        let scalingFactor = time100 / time10
        
        #expect(scalingFactor < 20, "Performance should scale roughly linearly, got scaling factor \(scalingFactor)")
        
        let view1 = Text("Test1").debugScan("Label1")
        let view2 = Text("Test2").debugScan("Label2") 
        let type1 = String(describing: type(of: view1))
        let type2 = String(describing: type(of: view2))
        
        #expect(type1 == type2, "Same view+modifier combinations should have identical types")
    }
    
    @Test("Thread safety of module components")
    func testThreadSafety() async {
        let renderState = RenderState()
        
        await withTaskGroup(of: Int.self) { group in
            for _ in 0..<10 {
                group.addTask {
                    await renderState.record()
                }
            }
            
            var results: [Int] = []
            for await result in group {
                results.append(result)
            }
            
            let uniqueResults = Set(results)
            #expect(uniqueResults.count == 10)
        }
    }
}

/// Tests for edge cases and error conditions
@Suite("Edge Case Tests")
struct EdgeCaseTests {
    
    @Test("debugScan with extremely long labels")
    @MainActor func testExtremelyLongLabels() {
        let testCases = [
            (length: 10, label: String(repeating: "Short", count: 2)),
            (length: 100, label: String(repeating: "Medium", count: 17)),
            (length: 1000, label: String(repeating: "VeryLongLabel", count: 77)),
            (length: 10000, label: String(repeating: "X", count: 10000))
        ]
        
        for (expectedLength, label) in testCases {
            let view = Text("Test").debugScan(label)
            let viewType = String(describing: type(of: view))
            
            #expect(viewType.contains("ModifiedContent"))
            
            let testModifier = ViewInstrumentationModifier(
                label: label,
                file: #file,
                fileID: #fileID,
                filePath: #filePath
            )
            
            #expect(testModifier.label == label, "Label should be preserved exactly, length: \(expectedLength)")
            #expect(testModifier.label.count >= Int(Double(expectedLength) * 0.8), "Label length should be approximately correct")
            
            let startTime = CFAbsoluteTimeGetCurrent()
            let _ = Text("Performance").debugScan(label)
            let endTime = CFAbsoluteTimeGetCurrent()
            let duration = endTime - startTime
            
            #expect(duration < 0.001, "Long label (\(expectedLength) chars) should not impact performance: \(duration)s")
        }
    }
    
    @Test("debugScan with special characters in labels")
    @MainActor func testSpecialCharacterLabels() {
        let specialLabels = [
            ("spaces", "Label with spaces"),
            ("newlines", "Label\nwith\nnewlines"),
            ("tabs", "Label\twith\ttabs"),
            ("quotes", "Label\"with\"quotes"),
            ("apostrophes", "Label'with'single'quotes"),
            ("backslashes", "Label\\with\\backslashes"),
            ("slashes", "Label/with/slashes"),
            ("brackets", "Label<with>brackets"),
            ("braces", "Label{with}braces"),
            ("square", "Label[with]square[brackets]"),
            ("control_chars", "Label\u{0001}\u{001F}Control"),
            ("mixed", "Mix: 123!@#$%^&*()+=~`")
        ]
        
        for (description, label) in specialLabels {
            let view = Text("Test").debugScan(label)
            let viewType = String(describing: type(of: view))
            
            #expect(viewType.contains("ModifiedContent"), "Failed for \(description): \(label)")
            
            let testModifier = ViewInstrumentationModifier(
                label: label,
                file: #file,
                fileID: #fileID,
                filePath: #filePath
            )
            
            #expect(testModifier.label == label, "Label should roundtrip correctly for \(description)")
            #expect(testModifier.label.count == label.count, "Label length should be preserved for \(description)")
            
            #expect(testModifier.file.hasSuffix("IntegrationTests.swift"))
            #expect(testModifier.module.count > 0)
            #expect(testModifier.filePath.count > 0)
        }
        
        let mod1 = ViewInstrumentationModifier(label: "Label\nWith\nNewlines", file: #file, fileID: #fileID, filePath: #filePath)
        let mod2 = ViewInstrumentationModifier(label: "Label\tWith\tTabs", file: #file, fileID: #fileID, filePath: #filePath)
        
        #expect(mod1.label != mod2.label, "Different special characters should create different labels")
        #expect(mod1.file == mod2.file, "Other properties should be identical")
        #expect(mod1.module == mod2.module, "Other properties should be identical")
    }
    
    @Test("debugScan with unicode labels")
    @MainActor func testUnicodeLabels() {
        let unicodeLabels = [
            ("emoji", "🚀 Rocket Label 🚀"),
            ("japanese", "日本語ラベル"),
            ("arabic", "العربية"), 
            ("cyrillic", "Русский"),
            ("flag", "🇺🇸"),
            ("diacritics", "Ĥëļļø Wørłđ"),
            ("math", "数学: ∑∞=1 1/n²"),
            ("combined", "🌍 Hello სამყარო Κόσμος 世界 🌎"),
            ("rtl_ltr", "English العربية English"),
            ("complex_emoji", "👨‍👩‍👧‍👦🤼‍♂️")
        ]
        
        for (description, label) in unicodeLabels {
            let view = Text("Test").debugScan(label)
            let viewType = String(describing: type(of: view))
            
            #expect(viewType.contains("ModifiedContent"), "Failed for \(description): \(label)")
            
            let testModifier = ViewInstrumentationModifier(
                label: label,
                file: #file,
                fileID: #fileID,
                filePath: #filePath
            )
            
            #expect(testModifier.label == label, "Unicode label should be preserved exactly for \(description)")
            
            let labelByteCount = label.utf8.count
            let labelCharCount = label.count
            #expect(labelByteCount >= labelCharCount, "Byte count should be >= character count for \(description)")
            
            let interpolated = "Debug: \(label)"
            #expect(interpolated.contains(label), "Unicode should work in string interpolation for \(description)")
            
            let normalizedLabel = label.precomposedStringWithCanonicalMapping
            let normalizedModifier = ViewInstrumentationModifier(
                label: normalizedLabel,
                file: #file,
                fileID: #fileID,
                filePath: #filePath
            )
            
            #expect(normalizedModifier.label == normalizedLabel, "Normalized unicode should work for \(description)")
        }
        
        let sortedLabels = unicodeLabels.map(\.1).sorted()
        #expect(sortedLabels.count == unicodeLabels.count, "Unicode labels should be sortable")
        
        let unicode1 = ViewInstrumentationModifier(label: "🚀 Test", file: #file, fileID: #fileID, filePath: #filePath)
        let unicode2 = ViewInstrumentationModifier(label: "🚀 Test", file: #file, fileID: #fileID, filePath: #filePath)
        
        #expect(unicode1.label == unicode2.label, "Identical unicode strings should be equal")
    }
    
    @Test("ViewInstrumentationModifier with extreme file paths")
    @MainActor func testExtremeFilePaths() {
        let longPath: StaticString = "/very/long/path/to/some/deeply/nested/directory/structure/File.swift"
        
        let modifier = ViewInstrumentationModifier(
            label: "Test",
            file: longPath,
            fileID: "Module/File.swift",
            filePath: longPath
        )
        
        #expect(modifier.file == "File.swift")
        #expect(modifier.module == "Module")
    }
}
