//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 19.03.2024.
//

import Foundation
import JsonRpcClient

public enum JsonRpc {
    public struct Request {

        public enum Kind {
            case single(Request)
            case batch([Request])
        }

        public var isInvocation: Bool {
            id != nil
        }

        public let jsonrpc: JsonRpcVersion
        public let id: JsonRpcId?
        public let method: String

        private let container: KeyedDecodingContainer<DecodingKeys>

        public func params<T: Decodable>(_ type: T.Type = T.self) throws -> T {
            try container.decode(T.self, forKey: .params)
        }
    }

    public struct Response {
        private let jsonrpc: JsonRpcVersion
        private let id: JsonRpcId?
        private let resultEncoder: (inout KeyedEncodingContainer<EncodingKeys>) throws -> Void
    }
}

// MARK: -

extension JsonRpc.Request: Decodable {

    private enum DecodingKeys: String, CodingKey {
        case jsonrpc
        case id
        case method
        case params
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        self.jsonrpc = try container.decode(JsonRpcVersion.self, forKey: .jsonrpc)
        self.id = try container.contains(.id) ? container.decode(JsonRpcId.self, forKey: .id) : nil
        self.method = try container.decode(String.self, forKey: .method)
        self.container = container
    }
}

// MARK: -

extension JsonRpc.Response: Encodable {

    private enum EncodingKeys: String, CodingKey {
        case jsonrpc
        case id
        case result
        case error
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(jsonrpc, forKey: .jsonrpc)
        try container.encodeIfPresent(id, forKey: .id)
        try resultEncoder(&container)
    }
}

// MARK: - Error response

extension JsonRpc.Response {

    private struct Error<T: Encodable>: Encodable {
        let code: Int
        let message: String
        let data: T?
    }

    public static func error<T: Encodable>(error code: Int, message: String, data: T = Optional<String>.none) -> JsonRpc.Response {
        JsonRpc.Response(jsonrpc: .v2_0, id: .null) {
            try $0.encode(Error(code: code, message: message, data: data), forKey: .error)
        }
    }
}

// MARK: - Response builder

extension JsonRpc.Response {
    public final class Builder {

        public var response: JsonRpc.Response? {
            guard let resultEncoder else {
                return nil
            }
            return JsonRpc.Response(jsonrpc: .v2_0, id: id, resultEncoder: resultEncoder)
        }

        private let id: JsonRpcId
        private var resultEncoder: ((inout KeyedEncodingContainer<EncodingKeys>) throws -> Void)?

        public init(id: JsonRpcId? = nil) {
            self.id = id ?? .null
        }

        public func `return`<T: Encodable>(result: T) {
            guard resultEncoder == nil else {
                fatalError("Any of the methods of JsonRpcResponseBuilder must be called only once!")
            }
            resultEncoder = {
                try $0.encode(result, forKey: .result)
            }
        }

        public func `return`<T: Encodable>(error code: Int, message: String, data: T) {
            guard resultEncoder == nil else {
                fatalError("Any of the methods of JsonRpcResponseBuilder must be called only once!")
            }
            resultEncoder = {
                try $0.encode(Error(code: code, message: message, data: data), forKey: .error)
            }
        }
    }
}

public extension JsonRpc.Response.Builder {

    @inlinable
    func returnNull() {
        self.return(result: Parameters.null)
    }

    @inlinable
    func returnEmpyObject() {
        self.return(result: Parameters.void)
    }

    @inlinable
    func `return`(error code: Int, message: String) {
        self.return(error: code, message: message, data: Optional<String>.none)
    }
}
