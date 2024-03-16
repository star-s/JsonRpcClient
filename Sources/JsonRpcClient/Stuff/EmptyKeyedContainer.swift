//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 06.03.2024.
//

import Foundation

struct EmptyKeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    let codingPath: [CodingKey] = []

    let allKeys: [Key] = []

    private var context: DecodingError.Context {
        DecodingError.Context(codingPath: codingPath, debugDescription: debugDescription)
    }

    let debugDescription: String

    init(debugDescription: String = "Container is empty!") {
        self.debugDescription = debugDescription
    }

    func contains(_ key: Key) -> Bool {
        false
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        throw DecodingError.keyNotFound(key, context)
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        throw DecodingError.keyNotFound(key, context)
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
