//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 19.03.2024.
//

import Foundation
import HttpClientUtilities
import HttpClientMocks
import JsonRpcClient

public protocol JsonRpcService {
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }

    func handle(request: URLRequest) async -> (data: Data, response: URLResponse)

    func implementation(for method: String) -> ((JsonRpc.Request, JsonRpc.Response.Builder) async -> Void)?
    func notificationHandler(_ name: String) -> ((JsonRpc.Request) async -> Void)?
}

extension JsonRpcService {
    public func handle(request: URLRequest) async -> (data: Data, response: URLResponse) {
        guard let httpBody = request.httpBody else {
            return httpResponse(for: request, statusCode: .badRequest)
        }
        do {
            let data = try await handleJsonRpc(data: httpBody)
            return httpResponse(for: request, data: data)
        } catch {
            return httpResponse(for: request, statusCode: .internalServerError)
        }
    }

    private func handleJsonRpc(data: Data) async throws -> TaggedData {
        if let request = try? decoder.decode(JsonRpc.Request.self, from: data) {
            guard let response = await handle(request: request) else {
                return Data().tagged(with: [])
            }
            return try TaggedData.jsonEncoded(response, encoder: encoder)
        }
        guard let batchRequest = try? decoder.decode([JsonRpc.Request.Box].self, from: data) else {
            return try TaggedData.jsonEncoded(JsonRpc.Response.error(error: -32700, message: "Parse error"))
        }
        if batchRequest.isEmpty {
            return try TaggedData.jsonEncoded(JsonRpc.Response.error(error: -32600, message: "Invalid Request"))
        }
        var responses: [JsonRpc.Response] = []
        for item in batchRequest {
            guard let request = try? item.unbox() else {
                responses.append(JsonRpc.Response.error(error: -32600, message: "Invalid Request"))
                continue
            }
            guard let response = await handle(request: request) else {
                continue
            }
            responses.append(response)
        }
        if responses.isEmpty {
            return Data().tagged(with: [])
        }
        return try TaggedData.jsonEncoded(responses, encoder: encoder)
    }

    private func handle(request: JsonRpc.Request) async -> JsonRpc.Response? {
        guard request.isInvocation else {
            await notificationHandler(request.method)?(request)
            return nil
        }
        let builder = JsonRpc.Response.Builder(id: request.id)

        guard let methodImplementation = implementation(for: request.method) else {
            builder.return(error: -32601, message: "Method not found")
            return builder.response
        }
        await methodImplementation(request, builder)
        if builder.response == nil {
            builder.returnNull()
        }
        return builder.response
    }
}
