//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 20.03.2024.
//

import XCTest
import HttpClient
import JsonRpcClientMocks

actor TestService: TransportLayer, JsonRpcService {
    private struct SubtractParams: Decodable {
        let minuend: Int
        let subtrahend: Int
    }

    let decoder: JSONDecoder = JSONDecoder()
    let encoder: JSONEncoder = JSONEncoder()

    private(set) var updateNotificationDidHandled = false
    private(set) var foobarNotificationDidHandled = false

    func resetNotifications() {
        updateNotificationDidHandled = false
        foobarNotificationDidHandled = false
    }

    // MARK: - TransportLayer

    func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        await handle(request: request)
    }

    // MARK: - JsonRpcService

    nonisolated func implementation(for method: String) -> ((JsonRpc.Request, JsonRpc.Response.Builder) async -> Void)? {
        switch method {
        case "subtract":
            return subtract(request:response:)
        case "sum":
            return sum(request:response:)
        case "get_data":
            return getData(request:response:)
        default:
            return nil
        }
    }

    nonisolated func notificationHandler(_ name: String) -> ((JsonRpc.Request) async -> Void)? {
        switch name {
        case "update":
            return updateNotification(request:)
        case "foobar":
            return foobarNotification(request:)
        default:
            return nil
        }
    }

    // MARK: - Method implementations

    private func subtract(request: JsonRpc.Request, response: JsonRpc.Response.Builder) async {
        if var numbers = try? request.params([Int].self) {
            let minuend = numbers.removeFirst()
            let result = numbers.reduce(minuend, { $0 - $1 })
            response.return(result: result)
        } else if let params = try? request.params(SubtractParams.self) {
            response.return(result: params.minuend - params.subtrahend)
        } else {
            response.return(error: -32602, message: "Invalid params")
        }
    }

    private func sum(request: JsonRpc.Request, response: JsonRpc.Response.Builder) async {
        do {
            let numbers = try request.params([Int].self)
            let result = numbers.reduce(0, { $0 + $1 })
            response.return(result: result)
        } catch {
            response.return(error: -32602, message: "Invalid params")
        }
    }

    private func getData(request: JsonRpc.Request, response: JsonRpc.Response.Builder) async {
        response.return(result: ["hello", "5"])
    }

    // MARK: - Notifications

    private func updateNotification(request: JsonRpc.Request) async {
        guard updateNotificationDidHandled == false else {
            XCTFail("Already handled!")
            return
        }
        updateNotificationDidHandled = true
    }

    private func foobarNotification(request: JsonRpc.Request) async {
        guard foobarNotificationDidHandled == false else {
            XCTFail("Already handled!")
            return
        }
        foobarNotificationDidHandled = true
    }
}
