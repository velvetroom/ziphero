import XCTest
@testable import ZipHero

class TestMap:XCTestCase {
    private var zip:ZipHero!
    private var directory:URL!
    
    override func setUp() {
        zip = ZipHero()
        directory = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("samples")
        try! FileManager.default.createDirectory(at:directory, withIntermediateDirectories:true)
        let sample1 = try! Data.init(contentsOf:Bundle(for:TestMap.self).url(
            forResource:"sample1", withExtension:"jpg")!)
        try! sample1.write(to:directory.appendingPathComponent("sample1.jpg"))
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at:directory)
    }
    
    func testMapSize() {
        print(Bundle(for:TestMap.self).url(forResource:"sample1", withExtension:"jpg")!)
        var package:Package!
        XCTAssertNoThrow(package = try zip.package(directory:directory))
        XCTAssertEqual(1, package.map.count)
        XCTAssertEqual(500, package.map.size)
    }
}
