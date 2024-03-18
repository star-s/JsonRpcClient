//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17.03.2024.
//

import Foundation
import HttpClientUtilities
import JsonRpcClient

public final class JsonRpcResponseBuilder {
    public struct Response: Encodable {
        fileprivate enum CodingKeys: String, CodingKey {
            case jsonrpc
            case result
            case error
            case id
        }

        fileprivate let jsonrpc: JsonRpcVersion
        fileprivate let id: JsonRpcId?
        fileprivate let resultEncoder: (inout KeyedEncodingContainer<CodingKeys>) throws -> Void

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(jsonrpc, forKey: .jsonrpc)
            try container.encodeIfPresent(id, forKey: .id)
            try resultEncoder(&container)
        }
    }

    private struct FailedResponse<T: Encodable>: Encodable {
        let code: Int
        let message: String
        let data: T?
    }

    public var response: Response? {
        guard let resultEncoder else {
            return nil
        }
        return Response(jsonrpc: .v2_0, id: id, resultEncoder: resultEncoder)
    }

    private let id: JsonRpcId
    private var resultEncoder: ((inout KeyedEncodingContainer<Response.CodingKeys>) throws -> Void)?

    public init(id: JsonRpcId? = nil) {
        self.id = id ?? .null
    }

    public func `return`() {
        guard resultEncoder == nil else {
            fatalError("Any of the methods of JsonRpcResponseBuilder must be called only once!")
        }
        resultEncoder = {
            try $0.encode(Parameters.void, forKey: .result)
        }
    }

    public func `return`<T: Encodable>(result: T) {
        guard resultEncoder == nil else {
            fatalError("Any of the methods of JsonRpcResponseBuilder must be called only once!")
        }
        resultEncoder = {
            try $0.encode(result, forKey: .result)
        }
    }

    public func `return`(error code: Int, message: String) {
        self.return(error: code, message: message, data: Optional<String>.none)
    }

    public func `return`<T: Encodable>(error code: Int, message: String, data: T) {
        guard resultEncoder == nil else {
            fatalError("Any of the methods of JsonRpcResponseBuilder must be called only once!")
        }
        resultEncoder = {
            try $0.encode(FailedResponse(code: code, message: message, data: data), forKey: .error)
        }
    }
}
