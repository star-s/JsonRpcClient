//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.02.2024.
//

import Foundation
import HttpClient

public struct JsonRpcResponseDecoder: ResponseDecoder {
    private let validator: ((URLResponse) async throws -> Void)?
    private let decoder: JSONDecoder

    public init(
        _ decoder: JSONDecoder = JSONDecoder(),
        validator: ((URLResponse) async throws -> Void)? = nil
    ) {
        self.validator = validator
        self.decoder = decoder
    }

    public func validate(response: (data: Data, response: URLResponse)) async throws {
        guard let validator else {
            return
        }
        try await validator(response.response)
    }

    public func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
        if T.self is [JsonRpcResponse].Type {
            if response.data.isEmpty {
                return [] as! T
            }
            if let item = try? decoder.decode(JsonRpcResponse.self, from: response.data) {
                throw try item.error()
            }
            return try decoder.decode(T.self, from: response.data)
        }
        let response = try decoder.decode(JsonRpcResponse.self, from: response.data)
        guard response.isSuccess else {
            throw try response.error()
        }
        return try response.result(T.self)
    }
}
