import XCTest
@testable import ZipHero

class TestPackage:XCTestCase {
    private var zip:ZipHero!
    private var directory:URL!
    private var sample1Size:Int!
    private var sample2Size:Int!
    private let headerSize = 16
    private let separatorSize = 8
    
    override func setUp() {
        zip = ZipHero()
        directory = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("samples")
        try! FileManager.default.createDirectory(at:directory, withIntermediateDirectories:true)
        let sample1 = try! Data.init(contentsOf:Bundle(for:TestPackage.self).url(
            forResource:"sample1", withExtension:"jpg")!)
        let sample2 = try! Data.init(contentsOf:Bundle(for:TestPackage.self).url(
            forResource:"sample2", withExtension:"jpg")!)
        try! sample1.write(to:directory.appendingPathComponent("sample1.jpg"))
        try! sample2.write(to:directory.appendingPathComponent("sample2.jpg"))
        sample1Size = sample1.count
        sample2Size = sample2.count
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at:directory)
    }
    
    func testPackageSuccedes() {
        XCTAssertNoThrow(try zip.package(directory:directory))
    }
    
    func testItemsCount() {
        guard let package = try? zip.package(directory:directory) else { return XCTFail() }
        XCTAssertEqual(2, package.items.count)
    }
    
    func testItemName() {
        guard let package = try? zip.package(directory:directory) else { return XCTFail() }
        XCTAssertEqual("sample1.jpg", package.items[0].name)
    }
    
    func testItem0Start() {
        guard let package = try? zip.package(directory:directory) else { return XCTFail() }
        XCTAssertEqual(headerSize, package.items[0].start)
    }
    
    func testItem0End() {
        guard let package = try? zip.package(directory:directory) else { return XCTFail() }
        XCTAssertEqual(headerSize + sample1Size, package.items[0].end)
    }
    
    func testItem0Size() {
        guard let package = try? zip.package(directory:directory) else { return XCTFail() }
        XCTAssertEqual(35343, package.items[0].end - package.items[0].start)
    }
    
    func testItem1Size() {
        guard let package = try? zip.package(directory:directory) else { return XCTFail() }
        XCTAssertEqual(50601, package.items[1].end - package.items[1].start)
    }
    
    func testItem1Start() {
        guard let package = try? zip.package(directory:directory) else { return XCTFail() }
        XCTAssertEqual(headerSize + sample1Size + separatorSize, package.items[1].start)
    }
    
    func testBlobSize() {
        guard let package = try? zip.package(directory:directory) else { return XCTFail() }
        XCTAssertEqual(sample1Size + sample2Size + headerSize + separatorSize, package.blob.count)
    }
}
