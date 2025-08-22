import Testing
import Foundation
@testable import SwiftUIDebugScan

/// Tests for the RenderState actor functionality
@Suite("RenderState Actor Tests")
struct RenderStateTests {
    
    @Test("RenderState starts with zero count")
    func testInitialRenderCount() async {
        let renderState = RenderState()
        let firstCount = await renderState.record()
        #expect(firstCount == 1)
    }
    
    @Test("RenderState increments count on each record call")
    func testRenderCountIncrement() async {
        let renderState = RenderState()
        
        let first = await renderState.record()
        let second = await renderState.record()
        let third = await renderState.record()
        
        #expect(first == 1)
        #expect(second == 2)
        #expect(third == 3)
    }
    
    @Test("RenderState handles concurrent access correctly")
    func testConcurrentAccess() async {
        let renderState = RenderState()
        
        async let task1 = renderState.record()
        async let task2 = renderState.record()
        async let task3 = renderState.record()
        async let task4 = renderState.record()
        async let task5 = renderState.record()
        
        let results = await [task1, task2, task3, task4, task5]
        
        let uniqueResults = Set(results)
        #expect(uniqueResults.count == 5)
        #expect(results.min() == 1)
        #expect(results.max() == 5)
        
        let sortedResults = results.sorted()
        #expect(sortedResults == [1, 2, 3, 4, 5])
    }
    
    @Test("RenderState maintains separate counts for different instances")
    func testSeparateInstances() async {
        let renderState1 = RenderState()
        let renderState2 = RenderState()
        
        let count1a = await renderState1.record()
        let count2a = await renderState2.record()
        let count1b = await renderState1.record()
        let count2b = await renderState2.record()
        
        #expect(count1a == 1)
        #expect(count2a == 1)
        #expect(count1b == 2)
        #expect(count2b == 2)
    }
}
