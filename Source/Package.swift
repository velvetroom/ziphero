import Foundation

public class Package {
    public private(set) var data = Data()
    private(set) var items = [Item]()
    private let separator = 0
    
    func append(data:Data, name:String) {
        var item = add(blob:data)
        item.name = name
        items.append(item)
    }
    
    private func add(blob:Data) -> Item {
        var item = Item()
        item.start = data.count
        data.append(blob)
        item.end = data.count
        data.append(value:separator)
        return item
    }
}
