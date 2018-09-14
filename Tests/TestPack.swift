import XCTest
@testable import ZipHero

class TestPack:XCTestCase {
    private var zip:ZipHero!
    private var directory:URL!
    private var sample1Size:Int!
    private var sample2Size:Int!
    private var sample3Size:Int!
    
    override func setUp() {
        zip = ZipHero()
        directory = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("pack")
        try! FileManager.default.createDirectory(at:directory, withIntermediateDirectories:true)
        let sample1 = try! Data.init(contentsOf:Bundle(for:TestPack.self).url(
            forResource:"sample1", withExtension:"jpg")!)
        let sample2 = try! Data.init(contentsOf:Bundle(for:TestPack.self).url(
            forResource:"sample2", withExtension:"jpg")!)
        let sample3 = try! Data.init(contentsOf:Bundle(for:TestPack.self).url(
            forResource:"sample3", withExtension:"jpg")!)
        try! sample1.write(to:directory.appendingPathComponent("sample1.jpg"))
        try! sample2.write(to:directory.appendingPathComponent("sample2.jpg"))
        try! sample3.write(to:directory.appendingPathComponent("sample3.jpg"))
        sample1Size = sample1.count
        sample2Size = sample2.count
        sample3Size = sample3.count
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at:directory)
    }
    
    func testPackSuccedes() {
        XCTAssertNoThrow(try zip.pack(directory:directory))
    }
    
    func testItemsCount() {
        guard let package = try? zip.pack(directory:directory) else { return XCTFail() }
        XCTAssertEqual(3, package.items.count)
    }
    
    func testItemName() {
        guard let package = try? zip.pack(directory:directory) else { return XCTFail() }
        XCTAssertEqual("sample1.jpg", package.items[0].name)
    }
    
    func testItem0Start() {
        guard let package = try? zip.pack(directory:directory) else { return XCTFail() }
        XCTAssertEqual(0, package.items[0].start)
    }
    
    func testItemsSize() {
        guard let package = try? zip.pack(directory:directory) else { return XCTFail() }
        package.items.forEach { item in
            switch item.name {
            case "sample1.jpg": XCTAssertEqual(sample1Size, item.end - item.start)
            case "sample2.jpg": XCTAssertEqual(sample2Size, item.end - item.start)
            case "sample3.jpg": XCTAssertEqual(sample3Size, item.end - item.start)
            default: XCTFail()
            }
        }
    }
    
    func testDataSize() {
        guard let package = try? zip.pack(directory:directory) else { return XCTFail() }
        XCTAssertEqual(sample1Size + sample2Size + sample3Size, package.data.count)
    }
}
