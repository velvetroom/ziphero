import XCTest
@testable import ZipHero

class TestUnzip:XCTestCase {
    private var zip:ZipHero!
    private var data:Data!
    private var directory:URL!
    
    override func setUp() {
        zip = ZipHero()
        data = try! Data(contentsOf:Bundle(for:TestUnzip.self).url(forResource:"zip", withExtension:"data")!)
        directory = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("unzip")
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at:directory)
    }
    
    func testNoThrows() {
        XCTAssertNoThrow(try zip.unzip(data:data, directory:directory))
    }
    
    func testThrowsIfNoHeader() {
        XCTAssertThrowsError(try zip.unzip(data:Data(), directory:directory))
    }
    
    func testUnzipedItems() {
        try? zip.unzip(data:data, directory:directory)
        XCTAssertTrue(FileManager.default.fileExists(atPath:directory.appendingPathComponent("sample1.jpg").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath:directory.appendingPathComponent("sample2.jpg").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath:directory.appendingPathComponent("sample3.jpg").path))
    }
}
