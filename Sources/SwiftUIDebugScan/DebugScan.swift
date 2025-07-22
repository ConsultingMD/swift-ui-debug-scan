import Foundation
import OSLog
import SwiftUI

private let logger = Logger(subsystem: "com.swift.instrument", category: "SwiftUI")
private let processInfo = ProcessInfo.processInfo

private let isVerbose: Bool = {
    guard let value = processInfo.environment["SWIFTUI_INSTRUMENT_VERBOSE"]?.lowercased() else {
        return false
    }
    return ["1", "true", "yes"].contains(value)
}()

#if DEBUG
@_silgen_name("swift_demangle")
private func swift_demangle(
    mangledName: UnsafePointer<CChar>?,
    mangledNameLength: UInt,
    outputBuffer: UnsafeMutablePointer<CChar>?,
    outputBufferSize: UnsafeMutablePointer<UInt>?,
    flags: UInt32
) -> UnsafeMutablePointer<CChar>?

fileprivate extension String {
    var demangled: String? {
        utf8CString.withUnsafeBufferPointer {
            guard let ptr = swift_demangle(
                mangledName: $0.baseAddress,
                mangledNameLength: UInt($0.count - 1),
                outputBuffer: nil,
                outputBufferSize: nil,
                flags: 0
            )
            else { return nil }
            defer { free(ptr) }
            return String(cString: ptr)
        }
    }
}

fileprivate extension TaskPriority {
    var label: String {
        switch self.rawValue {
        case 9: "background"
        case 17: "utility"
        case 21: "default"
        case 25: "userInitiated"
        case 33: "userInteractive"
        case 0: "unspecified"
        default: "❓ unknown (\(rawValue))"
        }
    }
}

#endif

func __dumpSUIDebugInfo() {
#if DEBUG
    let initialUptime = processInfo.systemUptime
    var lastThreadInfo = "N/A", lastStackSize = "N/A", lastTaskPriority = "N/A"
    let callStack = Thread.callStackSymbols
    
    for (idx, symbol) in zip(callStack.indices, callStack) {
        let mangled = symbol.utf8.drop { $0 != UInt8(ascii: "$") }.prefix { $0 != UInt8(ascii: " ") }
        guard
            mangled.starts(with: "$s7SwiftUI".utf8),
            let demangled = String(Substring(mangled)).demangled
        else {
            continue
        }
        let elapsed = (processInfo.systemUptime - initialUptime) * 1000
        let frameNumber = String(format: "%02d", idx + 1)
        let threadID = if Thread.isMainThread {
            "main"
        } else {
            (Thread.current.name?.isEmpty == true ? "\(Thread.current.description)" : Thread.current.name) ?? "unknown"
        }
        
        logger.debug("""
        🧩 Stack #\(frameNumber)
            • 🧵 threadID: \(threadID)
            • ⏱️ elapsed: \(String(format: "%.3f", elapsed)) ms
            • ⒡ function: \(demangled)
        """
        )
        lastThreadInfo = Thread.isMainThread ? "main" : String(reflecting: Thread.current)
        lastStackSize = ByteCountFormatter().string(for: Thread.current.stackSize)!
        lastTaskPriority = Task.currentPriority.label
    }
    
    let osThreadInfo = """
    💻 OS
        • 🧵 thread: \(lastThreadInfo)
        • 💾 stack size: \(lastStackSize)
        • 🚦 priority: \(lastTaskPriority)
        • ⚙️ processors: \(processInfo.activeProcessorCount) (Active) / \(processInfo.processorCount) (Total)
        • 📦 memory: \(ByteCountFormatter().string(fromByteCount: Int64(processInfo.physicalMemory)))
        • ⬆️ uptime: \(String(format: "%.3f", processInfo.systemUptime / 3600)) hours
    """
    logger.debug("\(osThreadInfo)")
#endif
}

private actor RenderState: ObservableObject {
    private var renderCount = 0
    
    func record() -> Int {
        renderCount += 1
        return renderCount
    }
}

struct ViewInstrumentationModifier: ViewModifier {
    @StateObject private var renderState = RenderState()
    var label: String
    var file: String
    var filePath: String
    var module: String

    private var fileForDisplay: String {
        isVerbose ? "open \(filePath)" : file
    }

    init(label: String, file: StaticString, fileID: StaticString, filePath: StaticString) {
        self.label = label
        self.filePath = "\(filePath)"
        self.file = "\(file)".components(separatedBy: "/").last ?? "unknown.swift"
        self.module = "\(fileID)".components(separatedBy: "/").first ?? "unknown"
        if isVerbose {
            __dumpSUIDebugInfo()
        }
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .task {
                let count = await renderState.record()
                logger.debug("""
                    🧩 [\(label)]
                        • 📂 file: \(fileForDisplay)
                        • 📚 module: \(module)
                        • 🎨 redraws: \(count)
                        • ⏱️ timestamp: \(Date())
                    """
                )
            }
    }
}

package extension View {
    func instrument(
        _ label: String,
        file: StaticString = #file,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath
    ) -> some View {
        modifier(
            ViewInstrumentationModifier(
                label: label,
                file: file,
                fileID: fileID,
                filePath: filePath
            )
        )
    }
}

