//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 18.03.2024.
//

import Foundation
import JsonRpcClient

extension URLRequest {
    public struct Request: Decodable {
        private enum DecodingKeys: String, CodingKey {
            case jsonrpc
            case method
            case params
            case id
        }

        public let jsonrpc: JsonRpcVersion
        public let id: JsonRpcId?

        public let method: String

        public var isInvocation: Bool {
            id != nil
        }

        private let container: KeyedDecodingContainer<DecodingKeys>

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: DecodingKeys.self)
            self.jsonrpc = try container.decode(JsonRpcVersion.self, forKey: .jsonrpc)
            self.id = try container.decodeIfPresent(JsonRpcId.self, forKey: .id)
            self.method = try container.decode(String.self, forKey: .method)
            self.container = container
        }

        public func params<T: Decodable>(_ type: T.Type = T.self) throws -> T {
            try container.decode(T.self, forKey: .params)
        }
    }

    public func jsonRpcRequest(decoder: JSONDecoder = JSONDecoder()) throws -> Request {
        guard let httpBody else {
            throw URLError(.cannotDecodeContentData)
        }
        return try decoder.decode(Request.self, from: httpBody)
    }
}
