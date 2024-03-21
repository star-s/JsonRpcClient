//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public struct JsonRpcResponse: Decodable {
    private enum DecodingKeys: String, CodingKey {
        case jsonrpc
        case result
        case error
        case id
    }

    public var isSuccess: Bool {
        container.contains(.result)
    }

    public var isFailure: Bool {
        container.contains(.error)
    }

    public let jsonrpc: JsonRpcVersion
    public let id: JsonRpcId

    private let container: KeyedDecodingContainer<DecodingKeys>

    public init<T: Decodable>(_ result: Result<T, JsonRpcError>, id: JsonRpcId) {
        self.jsonrpc = .v2_0
        self.id = id
        switch result {
        case .success(let success):
            self.container = [
                .result: success
            ]
        case .failure(let failure):
            self.container = [
                .error: failure
            ]
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        guard container.contains(.result) != container.contains(.error) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Either the result member or error member MUST be included, but both members MUST NOT be included."
                )
            )
        }
        jsonrpc = try container.decode(JsonRpcVersion.self, forKey: .jsonrpc)
        id = try container.decode(JsonRpcId.self, forKey: .id)
        self.container = container
    }

    public func result<T: Decodable>(_ type: T.Type = T.self) throws -> T {
        try container.decode(T.self, forKey: .result)
    }

    public func error() throws -> JsonRpcError {
        try container.decode(JsonRpcError.self, forKey: .error)
    }
}

public extension Array where Element == JsonRpcResponse {
    @inlinable
    func item(id: JsonRpcId) -> JsonRpcResponse? {
        first(where: { $0.id == id })
    }
}
