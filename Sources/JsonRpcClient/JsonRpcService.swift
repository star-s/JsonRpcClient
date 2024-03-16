//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public protocol JsonRpcService {

    func invoke<E: Encodable, D: Decodable>(method: String, params: E) async throws -> D
    func notify<E: Encodable>(method: String, params: E) async throws

    func performBatch(requests: [JsonRpcRequest]) async throws -> [JsonRpcResponse<AnyDecodable>]
}
