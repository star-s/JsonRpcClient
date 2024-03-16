//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 06.03.2024.
//

import Foundation

struct SingleValueContainer<Key: CodingKey, Value: Decodable>: KeyedDecodingContainerProtocol {
    private let key: Key
    private let value: Value

    private var context: DecodingError.Context {
        DecodingError.Context(codingPath: codingPath, debugDescription: "")
    }

    init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
}

extension SingleValueContainer {

    var codingPath: [CodingKey] { [] }

    var allKeys: [Key] { [key] }

    func contains(_ key: Key) -> Bool {
        self.key.stringValue == key.stringValue
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = value as? Bool else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return value
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let result = value as? (any StringProtocol) else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return String(result)
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = value as? (any BinaryFloatingPoint) else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return Double(value)
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = value as? (any BinaryFloatingPoint) else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return Float(value)
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = value as? (any BinaryInteger) else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return Int(value)
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = value as? (any BinaryInteger) else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return Int8(value)
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = value as? (any BinaryInteger) else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return Int16(value)
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = value as? (any BinaryInteger) else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return Int32(value)
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = value as? (any BinaryInteger) else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return Int64(value)
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = value as? (any UnsignedInteger) else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return UInt(value)
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = value as? (any UnsignedInteger) else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return UInt8(value)
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = value as? (any UnsignedInteger) else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return UInt16(value)
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = value as? (any UnsignedInteger) else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return UInt32(value)
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let value = value as? (any UnsignedInteger) else {
            throw DecodingError.typeMismatch(Value.self, context)
        }
        return UInt64(value)
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        guard contains(key) else {
            throw DecodingError.keyNotFound(key, context)
        }
        guard let result = value as? T else {
            throw DecodingError.typeMismatch(Value.self, context)
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
