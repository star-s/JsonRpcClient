//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 19.03.2024.
//

import Foundation
import CoreServices
import HttpClientMocks

public protocol JsonRpcService: TransportLayer {
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }

    func implementation(for method: String) -> ((JsonRpc.Request, JsonRpc.Response.Builder) async -> Void)?
    func notificationHandler(_ name: String) -> ((JsonRpc.Request) async -> Void)?
}

extension JsonRpcService {
    public func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        guard let requestKind = try? request.decodeJsonRpcRequest(decoder: decoder) else {
            return try handleURLRequest(request) {
                try TaggedData.jsonEncoded(JsonRpc.Response.error(error: -32700, message: "Parse error"))
            }
        }
        do {
            let data = try await handleJsonRpc(request: requestKind)
            return try handleURLRequest(request) { data }
        } catch {
            return try handleURLRequest(request) {
                // ???: HTTP error 5xx?
                try TaggedData.jsonEncoded(JsonRpc.Response.error(error: -32603, message: "Internal error"))
            }
        }
    }

    private func handleJsonRpc(request kind: JsonRpc.Request.Kind) async throws -> TaggedData {
        switch kind {
        case .single(let request):
            guard let response = await handle(request: request) else {
                return Data().tag(as: kUTTypeJSON)
            }
            return try TaggedData.jsonEncoded(response, encoder: encoder)
        case .batch(let requests):
            var responses: [JsonRpc.Response] = []
            for request in requests {
                guard let response = await handle(request: request) else {
                    continue
                }
                responses.append(response)
            }
            return try TaggedData.jsonEncoded(responses, encoder: encoder)
        }
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
