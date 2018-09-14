import Foundation

class Package {
    private(set) var data = Data()
    private(set) var items = [Item]()
    
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
        return item
    }
}
