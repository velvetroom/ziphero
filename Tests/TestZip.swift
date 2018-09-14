import XCTest
@testable import ZipHero

class TestZip:XCTestCase {
    private var zip:ZipHero!
    private var directory:URL!
    
    override func setUp() {
        zip = ZipHero()
        directory = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("zip")
        try! FileManager.default.createDirectory(at:directory, withIntermediateDirectories:true)
        let sample1 = try! Data.init(contentsOf:Bundle(for:TestZip.self).url(
            forResource:"sample1", withExtension:"jpg")!)
        let sample2 = try! Data.init(contentsOf:Bundle(for:TestZip.self).url(
            forResource:"sample2", withExtension:"jpg")!)
        let sample3 = try! Data.init(contentsOf:Bundle(for:TestZip.self).url(
            forResource:"sample3", withExtension:"jpg")!)
        try! sample1.write(to:directory.appendingPathComponent("sample1.jpg"))
        try! sample2.write(to:directory.appendingPathComponent("sample2.jpg"))
        try! sample3.write(to:directory.appendingPathComponent("sample3.jpg"))
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at:directory)
    }
    
    func testZipSuccedes() {
        XCTAssertNoThrow(try zip.zip(directory:directory))
    }
    
    func testDescriptorSize() {
        let data = try! zip.zip(directory:directory)
        XCTAssertEqual(144, data.subdata(in:16 ..< 24).value())
    }
    
    func testHeader() {
        let data = try! zip.zip(directory:directory)
        XCTAssertEqual("iturbide.ZipHero", String(data:data.subdata(in:0 ..< 16), encoding:.utf8))
    }
    
    func testPackage() {
        let data = try! zip.zip(directory:directory)
        XCTAssertNotNil(try? JSONDecoder().decode([Item].self, from:data.subdata(in:24 ..< 168)))
    }
    
    func testDataSize() {
        let data = try! zip.zip(directory:directory)
        XCTAssertEqual(45466, data.count)
    }
    
    func testSave() {
        let data = try! zip.zip(directory:directory)
        let url = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("zop.data")
        try! data.write(to:url)
        print(url)
    }
}
