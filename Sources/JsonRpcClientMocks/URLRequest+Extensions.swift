//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 18.03.2024.
//

import Foundation

public extension URLRequest {
    func decodeJsonRpcRequest(decoder: JSONDecoder = JSONDecoder()) throws -> JsonRpc.Request.Kind {
        guard let httpBody else {
            throw URLError(.cannotDecodeContentData)
        }
        do {
            return try .single(decoder.decode(JsonRpc.Request.self, from: httpBody))
        } catch {
            if let requests = try? decoder.decode([JsonRpc.Request].self, from: httpBody) {
                return .batch(requests)
            }
            throw error
        }
    }
}
