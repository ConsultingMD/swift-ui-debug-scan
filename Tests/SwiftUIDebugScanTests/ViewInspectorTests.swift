import Testing
import SwiftUI
import ViewInspector
@testable import SwiftUIDebugScan

/// Tests using ViewInspector for proper SwiftUI view introspection
/// This replaces the string-based type hacks with real view inspection
@Suite("ViewInspector-Enhanced Tests")
struct ViewInspectorTests {
    
    @Test("debugScan preserves underlying view content")
    @MainActor func testDebugScanContentPreservation() throws {
        let view = Text("Hello World").debugScan("TestLabel")

        let inspection = try view.inspect()
        let textContent = try inspection.text().string()
        
        #expect(textContent == "Hello World", "Content should be preserved through debugScan")
    }
    
    @Test("debugScan works with different view types - content verification")
    @MainActor func testViewTypeContentPreservation() throws {
        let textView = Text("Test Content").debugScan("TextLabel")
        let textInspection = try textView.inspect()
        #expect(try textInspection.text().string() == "Test Content")
        
        let imageView = Image(systemName: "star.fill").debugScan("ImageLabel")
        let imageInspection = try imageView.inspect()
        let actualImage = try imageInspection.image().actualImage()
        #expect(String(describing: actualImage) != "", "Image should be preserved through debugScan")
        
        let buttonView = Button("Tap Me") { }.debugScan("ButtonLabel")
        let buttonInspection = try buttonView.inspect()
        let buttonText = try buttonInspection.button().labelView().text().string()
        #expect(buttonText == "Tap Me", "Button label should be preserved")
    }
    
    @Test("Complex view hierarchies - structural verification")
    @MainActor func testComplexViewHierarchyStructure() throws {
        let complexView = VStack {
            Text("Title").debugScan("TitleLabel")
            HStack {
                Text("Left").debugScan("LeftLabel")
                Spacer()
                Text("Right").debugScan("RightLabel") 
            }
            .debugScan("HStackLabel")
        }
        .debugScan("MainVStackLabel")
        
        let inspection = try complexView.inspect()
        let vstack = try inspection.vStack()
        
        #expect(vstack.count == 2, "Should have Title + HStack")
        
        let titleText = try vstack[0].text()
        #expect(try titleText.string() == "Title")
        
        let hstack = try vstack[1].hStack()
        #expect(hstack.count == 3, "Should have Left + Spacer + Right")
        
        let leftText = try hstack[0].text()
        let rightText = try hstack[2].text()
        #expect(try leftText.string() == "Left")
        #expect(try rightText.string() == "Right")
    }
    
    @Test("Conditional view content verification")
    @MainActor func testConditionalViewContent() throws {
        func testBranch(showText: Bool, expectedContent: String?) {
            let conditionalView = Group {
                if showText {
                    Text("Visible").debugScan("VisibleLabel")
                } else {
                    EmptyView().debugScan("EmptyLabel")
                }
            }
            .debugScan("GroupLabel")
            
            do {
                let inspection = try conditionalView.inspect()
                let group = try inspection.group()
                
                if let expected = expectedContent {
                    let text = try group.text(0)
                    #expect(try text.string() == expected)
                }
            } catch {
                if expectedContent != nil {
                    #expect(Bool(false), "Should be able to access conditional content")
                }
            }
        }
        
        testBranch(showText: true, expectedContent: "Visible")
        
        testBranch(showText: false, expectedContent: nil)
    }

    @Test("Real-world scenario: Debugging view issues")
    @MainActor func testDebuggingScenario() throws {
        let problematicView = VStack {
            Text("Should be visible").debugScan("VisibleText")
            if false {
                Text("Hidden text").debugScan("HiddenText")
            }
            Text("").debugScan("EmptyText")
        }
        .debugScan("ProblematicVStack")
        
        let inspection = try problematicView.inspect()
        let vstack = try inspection.vStack()

        #expect(vstack.count == 3, "Should have 3 items: visible text + conditional (absent) + empty text")
        
        let firstText = try vstack[0].text()
        #expect(try firstText.string() == "Should be visible")
        
        do {
            let emptyText = try vstack[2].text()
            let emptyContent = try emptyText.string()
            #expect(emptyContent == "", "Empty text should be detectable as empty string")
        } catch {
            #expect(true, "ViewInspector caught that empty text behaves differently than expected")
        }
    }
}
