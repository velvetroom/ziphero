import XCTest
@testable import ZipHero

class TestUnpack:XCTestCase {
    private var zip:ZipHero!
    private var data:Data!
    private var items:[Item]!
    private var directory:URL!
    
    override func setUp() {
        zip = ZipHero()
        data = try! Data(contentsOf:Bundle(for:TestUnpack.self).url(forResource:"export", withExtension:"data")!)
        let json = try! Data(contentsOf:Bundle(for:TestUnpack.self).url(forResource:"export", withExtension:"json")!)
        items = try! JSONDecoder().decode([Item].self, from:json)
        directory = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("unpack")
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at:directory)
    }
    
    func testUnpack() {
        XCTAssertNoThrow(try zip.unpack(data:data, items:items, destination:directory))
    }
    
    func testCreatesDirectory() {
        try? zip.unpack(data:data, items:items, destination:directory)
        XCTAssertTrue(FileManager.default.fileExists(atPath:directory.path))
    }
    
    func testUnpackedItems() {
        try? zip.unpack(data:data, items:items, destination:directory)
        XCTAssertTrue(FileManager.default.fileExists(atPath:directory.appendingPathComponent("sample1.jpg").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath:directory.appendingPathComponent("sample2.jpg").path))
    }
    
    func testSampleSizes() {
        try? zip.unpack(data:data, items:items, destination:directory)
        let blob0 = try! Data(contentsOf:directory.appendingPathComponent("sample1.jpg"))
        let blob1 = try! Data(contentsOf:directory.appendingPathComponent("sample2.jpg"))
        XCTAssertEqual(items[0].end - items[0].start, blob0.count)
        XCTAssertEqual(items[1].end - items[1].start, blob1.count)
    }
    
    func testExceptionSizeNotMatching() {
        XCTAssertThrowsError(try zip.unpack(data:Data(), items:items, destination:directory))
    }
}
