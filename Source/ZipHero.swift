import Foundation

public class ZipHero {
    public init() { }
    
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
        let package = Package()
        try files.forEach { file in
            let data = try Data(contentsOf:directory.appendingPathComponent(file))
            package.append(data:data, name:file)
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
}
