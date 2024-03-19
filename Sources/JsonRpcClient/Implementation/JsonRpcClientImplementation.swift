//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 06.03.2024.
//

import Foundation
import HttpClient

public protocol JsonRpcClientImplementation: JsonRpcClient, ApplicationLayer, ApplicationLayerWithoutReturnValue {
    var endpoint: Path { get }
}

public extension JsonRpcClientImplementation {
    func invoke<E: Encodable, D: Decodable>(method: String, params: E) async throws -> D {
        try await post(endpoint, parameters: JsonRpcRequest.invocation(method: method, params: params, id: .string(UUID().uuidString)))
    }

    func notify<E: Encodable>(method: String, params: E) async throws {
        try await post(endpoint, parameters: JsonRpcRequest.notification(method: method, params: params))
    }

    func performBatch(requests: [JsonRpcRequest]) async throws -> [JsonRpcResponse<AnyDecodable>] {
        try await post(endpoint, parameters: requests)
    }
}

public extension JsonRpcClientImplementation where Self: HttpClientWithBaseURL, Path: ExpressibleByStringLiteral {
    var endpoint: Path { "/" }
}
