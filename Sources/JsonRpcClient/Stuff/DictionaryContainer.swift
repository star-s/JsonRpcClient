//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 06.03.2024.
//

import Foundation


extension KeyedDecodingContainer: ExpressibleByDictionaryLiteral {
    public typealias Value = Any

    public init(dictionaryLiteral elements: (Key, Value)...) {
        var storage: [String: Any] = [:]
        var allKeys: [Key] = []

        elements.forEach {
            storage[$0.0.stringValue] = $0.1
            allKeys.append($0.0)
        }
        self.init(DictionaryContainer(allKeys: allKeys, storage: storage))
    }
}

struct DictionaryContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    let codingPath: [CodingKey] = []
    let allKeys: [Key]

    private var context: DecodingError.Context {
        DecodingError.Context(codingPath: codingPath, debugDescription: "")
    }

    private let storage: [String: Any]

    init<Value: Decodable>(key: Key, value: Value) {
        storage = [
            key.stringValue : value
        ]
        allKeys = [key]
    }

    fileprivate init(allKeys: [Key], storage: [String : Any]) {
        self.allKeys = allKeys
        self.storage = storage
    }
}

extension DictionaryContainer {

    func contains(_ key: Key) -> Bool {
        storage.keys.contains(key.stringValue)
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = storage[key.stringValue] as? Bool else {
            throw DecodingError.typeMismatch(Bool.self, context)
        }
        return value
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let result = storage[key.stringValue] as? (any StringProtocol) else {
            throw DecodingError.typeMismatch(String.self, context)
        }
        return String(result)
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = storage[key.stringValue] as? (any BinaryFloatingPoint) else {
            throw DecodingError.typeMismatch(Double.self, context)
        }
        return Double(value)
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = storage[key.stringValue] as? (any BinaryFloatingPoint) else {
            throw DecodingError.typeMismatch(Float.self, context)
        }
        return Float(value)
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = storage[key.stringValue] as? (any BinaryInteger) else {
            throw DecodingError.typeMismatch(Int.self, context)
        }
        return Int(value)
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = storage[key.stringValue] as? (any BinaryInteger) else {
            throw DecodingError.typeMismatch(Int8.self, context)
        }
        return Int8(value)
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = storage[key.stringValue] as? (any BinaryInteger) else {
            throw DecodingError.typeMismatch(Int16.self, context)
        }
        return Int16(value)
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = storage[key.stringValue] as? (any BinaryInteger) else {
            throw DecodingError.typeMismatch(Int32.self, context)
        }
        return Int32(value)
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = storage[key.stringValue] as? (any BinaryInteger) else {
            throw DecodingError.typeMismatch(Int64.self, context)
        }
        return Int64(value)
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = storage[key.stringValue] as? (any UnsignedInteger) else {
            throw DecodingError.typeMismatch(UInt.self, context)
        }
        return UInt(value)
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = storage[key.stringValue] as? (any UnsignedInteger) else {
            throw DecodingError.typeMismatch(UInt8.self, context)
        }
        return UInt8(value)
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = storage[key.stringValue] as? (any UnsignedInteger) else {
            throw DecodingError.typeMismatch(UInt16.self, context)
        }
        return UInt16(value)
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = storage[key.stringValue] as? (any UnsignedInteger) else {
            throw DecodingError.typeMismatch(UInt32.self, context)
        }
        return UInt32(value)
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = storage[key.stringValue] as? (any UnsignedInteger) else {
            throw DecodingError.typeMismatch(UInt64.self, context)
        }
        return UInt64(value)
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let result = storage[key.stringValue] as? T else {
            throw DecodingError.typeMismatch(T.self, context)
        }
        return result
    }

    func nestedContainer<NestedKey: CodingKey>(
        keyedBy type: NestedKey.Type, forKey key: Key
    ) throws -> KeyedDecodingContainer<NestedKey> {
        throw DecodingError.keyNotFound(key, context)
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw DecodingError.keyNotFound(key, context)
    }

    func superDecoder() throws -> Decoder {
        throw DecodingError.valueNotFound(Decoder.self, context)
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        throw DecodingError.keyNotFound(key, context)
    }
}
