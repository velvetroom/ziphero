import Foundation

public class Package {
    public private(set) var blob = Data()
    private(set) var items = [Item]()
    private let header = "iturbide.ZipHero"
    private let separator = 0
    
    init() {
        append(value:header)
    }
    
    func append(data:Data, name:String) {
        if !items.isEmpty { append(value:separator) }
        var item = add(data:data)
        item.name = name
        items.append(item)
    }
    
    private func add(data:Data) -> Item {
        var item = Item()
        item.start = blob.count
        blob.append(data)
        item.end = blob.count
        return item
    }
    
    private func append<T>(value:T) {
        var value:T = value
        blob.append(UnsafeBufferPointer(start:&value, count:1))
    }
}
