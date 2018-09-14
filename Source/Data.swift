import Foundation

extension Data {
    mutating func append<V>(value:V) {
        var value:V = value
        append(UnsafeBufferPointer(start:&value, count:1))
    }
    
    func value<T>() -> T? {
        return withUnsafeBytes { pointer -> T? in return Array(UnsafeBufferPointer(start:pointer, count:1)).first }
    }
}
