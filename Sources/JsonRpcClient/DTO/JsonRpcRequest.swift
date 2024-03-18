//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public struct JsonRpcRequest {
	public let jsonrpc: JsonRpcVersion
	public let method: String
	public let id: JsonRpcId?

	private let paramsEncoder: (inout KeyedEncodingContainer<CodingKeys>) throws -> Void

    private init<T: Encodable>(
        version: JsonRpcVersion = .v2_0,
        method: String,
        params: T,
        id: JsonRpcId?
    ) {
        self.jsonrpc = version
        self.method = method
        self.paramsEncoder = { try $0.encode(params, forKey: .params) }
        self.id = id
    }

    public static func notification<T: Encodable>(method: String, params: T) -> JsonRpcRequest {
        JsonRpcRequest(version: .v2_0, method: method, params: params, id: nil)
    }

    public static func invocation<T: Encodable>(method: String, params: T, id: JsonRpcId) -> JsonRpcRequest {
        JsonRpcRequest(version: .v2_0, method: method, params: params, id: id)
    }
}

extension JsonRpcRequest: Encodable {

	private enum CodingKeys: String, CodingKey {
		case jsonrpc
		case method
		case params
		case id
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(jsonrpc, forKey: .jsonrpc)
		try container.encode(method, forKey: .method)
		try paramsEncoder(&container)
		try container.encodeIfPresent(id, forKey: .id)
	}
}
