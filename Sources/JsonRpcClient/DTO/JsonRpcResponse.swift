//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public struct JsonRpcResponse<T> {
	public let jsonrpc: JsonRpcVersion
	public let result: Result<T, JsonRpcError>
	public let id: JsonRpcId

	public init(
        jsonrpc: JsonRpcVersion,
        result: Result<T, JsonRpcError>,
        id: JsonRpcId
    ) {
		self.jsonrpc = jsonrpc
        self.result = result
		self.id = id
	}
}

extension JsonRpcResponse: Decodable where T: Decodable {
	
    private enum DecodingKeys: String, CodingKey {
        case jsonrpc
        case result
        case error
        case id
    }

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: DecodingKeys.self)

		if container.contains(.result) {
            result = try .success(container.decode(T.self, forKey: .result))
        } else {
            result = try .failure(container.decode(JsonRpcError.self, forKey: .error))
        }
		jsonrpc = try container.decode(JsonRpcVersion.self, forKey: .jsonrpc)
		id = try container.decode(JsonRpcId.self, forKey: .id)
	}
}
