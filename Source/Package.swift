import Foundation

public class Package {
    public private(set) var data = Data()
    private(set) var items = [Item]()
    private let header = "iturbide.ZipHero"
    private let separator = 0
    
    init() {
        append(value:header)
    }
    
    func append(data:Data, name:String) {
        if !items.isEmpty { append(value:separator) }
        var item = add(blob:data)
        item.name = name
        items.append(item)
    }
    
    private func add(blob:Data) -> Item {
        var item = Item()
        item.start = data.count
        data.append(blob)
        item.end = data.count
        return item
    }
    
    private func append<T>(value:T) {
        var value:T = value
        data.append(UnsafeBufferPointer(start:&value, count:1))
    }
}
