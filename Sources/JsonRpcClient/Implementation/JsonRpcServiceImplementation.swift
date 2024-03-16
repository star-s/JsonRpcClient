//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 06.03.2024.
//

import Foundation
import HttpClient

public protocol JsonRpcServiceImplementation: JsonRpcService, ApplicationLayer, ApplicationLayerWithoutReturnValue {
    var endpoint: Path { get }
}

public extension JsonRpcServiceImplementation {
    func invoke<E: Encodable, D: Decodable>(method: String, params: E) async throws -> D {
        try await post(endpoint, parameters: JsonRpcRequest(method: method, params: params, id: .null))
    }

    func notify<E: Encodable>(method: String, params: E) async throws {
        try await post(endpoint, parameters: JsonRpcRequest(method: method, params: params))
    }

    func performBatch(requests: [JsonRpcRequest]) async throws -> [JsonRpcResponse<AnyDecodable>] {
        try await post(endpoint, parameters: requests)
    }
}

public extension JsonRpcServiceImplementation where Self: HttpClientWithBaseURL, Path: ExpressibleByStringLiteral {
    var endpoint: Path { "/" }
}
