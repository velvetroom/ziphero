import Foundation

extension Data {
    mutating func append<V>(value:V) {
        var value:V = value
        append(UnsafeBufferPointer(start:&value, count:1))
    }
}
