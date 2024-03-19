//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 19.03.2024.
//

import Foundation

public struct JsonRpcServiceMock: JsonRpcService {
    public let decoder: JSONDecoder
    public let encoder: JSONEncoder

    private let implementations: [String: ((JsonRpc.Request, JsonRpc.Response.Builder) async throws -> Void)]
    private let notifications: [String: ((JsonRpc.Request) async throws -> Void)]

    public init(
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        implementations: [String : ((JsonRpc.Request, JsonRpc.Response.Builder) async throws -> Void)],
        notifications: [String : ((JsonRpc.Request) async throws -> Void)] = [:]
    ) {
        self.decoder = decoder
        self.encoder = encoder
        self.implementations = implementations
        self.notifications = notifications
    }

    public func implementation(for method: String) -> ((JsonRpc.Request, JsonRpc.Response.Builder) async throws -> Void)? {
        implementations[method]
    }

    public func notificationHandler(_ name: String) -> ((JsonRpc.Request) async throws -> Void)? {
        notifications[name]
    }
}
