//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 19.03.2024.
//

import Foundation
import HttpClient

public struct JsonRpcServiceMock: TransportLayer, JsonRpcService {
    public let decoder: JSONDecoder
    public let encoder: JSONEncoder

    private let implementations: [String: ((JsonRpc.Request, JsonRpc.Response.Builder) async -> Void)]
    private let notifications: [String: ((JsonRpc.Request) async -> Void)]

    public init(
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        implementations: [String : ((JsonRpc.Request, JsonRpc.Response.Builder) async -> Void)],
        notifications: [String : ((JsonRpc.Request) async -> Void)] = [:]
    ) {
        self.decoder = decoder
        self.encoder = encoder
        self.implementations = implementations
        self.notifications = notifications
    }

    // MARK: - TransportLayer

    public func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        await handle(request: request)
    }

    // MARK: - JsonRpcService

    public func implementation(for method: String) -> ((JsonRpc.Request, JsonRpc.Response.Builder) async -> Void)? {
        implementations[method]
    }

    public func notificationHandler(_ name: String) -> ((JsonRpc.Request) async -> Void)? {
        notifications[name]
    }
}
