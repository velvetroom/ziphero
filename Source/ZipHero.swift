import Foundation

public class ZipHero {
    public init() { }
    private let header = "iturbide.ZipHero"
    
    public func zip(directory:URL) throws -> Data {
        var data = Data()
        let package = try pack(directory:directory)
        let items = try JSONEncoder().encode(package.items)
        data.append(header.data(using:.utf8)!)
        data.append(value:items.count)
        data.append(items)
        data.append(package.data)
        return data
    }
    
    public func unzip(data:Data, directory:URL) throws {
        try unpack(data:data, items:try unzipItems(data:data), destination:directory)
    }
    
    func pack(directory:URL) throws -> Package {
        let files = try FileManager.default.contentsOfDirectory(atPath:directory.path)
        return try pack(directory:directory, files:files)
    }
    
    func unpack(data:Data, items:[Item], destination:URL) throws {
        try validate(data:data, items:items)
        try FileManager.default.createDirectory(at:destination, withIntermediateDirectories:true)
        try items.forEach { item in
            try data.subdata(in:item.start ..< item.end).write(to:destination.appendingPathComponent(item.name))
        }
    }
    
    private func pack(directory:URL, files:[String]) throws -> Package {
        var package = Package()
        try files.forEach { file in
            let data = try Data(contentsOf:directory.appendingPathComponent(file))
            var item = Item()
            item.name = file
            item.start = package.data.count
            package.data.append(data)
            item.end = package.data.count
            package.items.append(item)
        }
        return package
    }
    
    private func validate(data:Data, items:[Item]) throws {
        try items.forEach { item in
            if item.end > data.count {
               throw Exception.invalidData
            }
        }
    }
    
    private func unzipItems(data:Data) throws -> [Item] {
        guard
            data.count > 24,
            header == String(data:data.subdata(in:0 ..< 16), encoding:.utf8),
            let size:Int = data.subdata(in:16 ..< 24).value(),
            data.count >= size + 24
        else { throw Exception.invalidHeader }
        return try JSONDecoder().decode([Item].self, from:data.subdata(in:24 ..< 24 + size))
    }
}
