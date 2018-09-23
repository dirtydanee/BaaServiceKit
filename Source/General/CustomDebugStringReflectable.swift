import Foundation

public protocol CustomDebugStringReflectable: CustomDebugStringConvertible {}

public extension CustomDebugStringReflectable {
    var debugDescription: String {
        let mirrored = Mirror(reflecting: self)
        return mirrored.children.reduce(into: "") { result, child in
            if let label = child.label {
                result.append("\(label): \(child.value)\n") }
        }
    }
}
