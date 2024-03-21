//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 06.03.2024.
//

import XCTest
@testable import JsonRpcClient

final class DictionaryContainerTests: XCTestCase {

    func testDecodable() {

        struct SomeStruct: Equatable, Decodable {
            var bool: Bool
            var string: String
            var number: Int
        }

        check(true)
        check(false)
        check("Some string")
        check(123)
        check(3.14)
        check(SomeStruct(bool: true, string: "Another string", number: 65536))
    }

    func testBool() {
        checkBool(true)
        checkBool(false)
    }

    func testString() {
        checkString("Some string")
    }

    func testDouble() {
        checkDouble(2.17)
        checkFloat(3.14)
    }

    func testInt() {
        checkInt(546)
        checkInt8(8)
        checkInt16(16)
        checkInt32(32)
        checkInt64(64)
    }

    func testUInt() {
        checkUInt(42)
        checkUInt8(123)
        checkUInt16(234)
        checkUInt32(345)
        checkUInt64(456)
    }
}

private extension DictionaryContainerTests {
    enum Keys: String, CodingKey {
        case testKey
    }

    func check<T: Decodable & Equatable>(_ value: T) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(T.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkBool(_ value: Bool) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(Bool.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkString(_ value: String) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(String.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkDouble(_ value: Double) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(Double.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkFloat(_ value: Float) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(Float.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkInt(_ value: Int) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(Int.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkInt8(_ value: Int8) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(Int8.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkInt16(_ value: Int16) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(Int16.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkInt32(_ value: Int32) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(Int32.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkInt64(_ value: Int64) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(Int64.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkUInt(_ value: UInt) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(UInt.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkUInt8(_ value: UInt8) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(UInt8.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkUInt16(_ value: UInt16) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(UInt16.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkUInt32(_ value: UInt32) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(UInt32.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func checkUInt64(_ value: UInt64) {
        let container = DictionaryContainer<Keys>(key: .testKey, value: value)
        do {
            let decodevValue = try container.decode(UInt64.self, forKey: .testKey)
            XCTAssertEqual(value, decodevValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
