import Foundation

public class ZipHero {
    public init() { }
    
    public func package(directory:URL) throws -> Package {
        let files = try FileManager.default.contentsOfDirectory(atPath:directory.path)
        return try pack(directory:directory, files:files)
    }
    
    private func pack(directory:URL, files:[String]) throws -> Package {
        let package = Package()
        try files.forEach { file in
            let data = try Data(contentsOf:directory.appendingPathComponent(file))
            package.append(data:data, name:file)
        }
        return package
    }
}
