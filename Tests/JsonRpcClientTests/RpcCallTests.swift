//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 19.03.2024.
//

import XCTest
@testable import JsonRpcClient
import JsonRpcClientMocks

final class RpcCallTests: XCTestCase {

    actor NotificationHandler {
        var updateNotificationDidHandled = false
        var foobarNotificationDidHandled = false

        func resetNotifications() {
            updateNotificationDidHandled = false
            foobarNotificationDidHandled = false
        }

        func updateNotification(request: JsonRpc.Request) async {
            guard updateNotificationDidHandled == false else {
                XCTFail("Already handled!")
                return
            }
            updateNotificationDidHandled = true
        }

        func foobarNotification(request: JsonRpc.Request) async {
            guard foobarNotificationDidHandled == false else {
                XCTFail("Already handled!")
                return
            }
            foobarNotificationDidHandled = true
        }
    }

    private lazy var client = OpenRpcClient(
        endpoint: "/",
        transport: JsonRpcServiceMock(
            implementations: [
                "subtract": JsonRpcServiceMock.subtract(request:response:),
                "sum": JsonRpcServiceMock.sum(request:response:),
                "get_data": JsonRpcServiceMock.getData(request:response:),
            ], notifications: [
                "update": notificationHandler.updateNotification(request:),
                "foobar": notificationHandler.foobarNotification(request:),
            ]
        ).withLogger()
    )

    private let notificationHandler = NotificationHandler()

    func testRpcCallWithPositionalParameters() async throws {
        let result1: Int = try await client.invoke(method: "subtract", params: [42, 23])
        XCTAssertEqual(result1, 19)
        let result2: Int = try await client.invoke(method: "subtract", params: [23, 42])
        XCTAssertEqual(result2, -19)
    }

    func testRpcCallWithNamedParameters() async throws {
        let result1: Int = try await client.invoke(method: "subtract", params: [
            "subtrahend" : 23,
            "minuend": 42,
        ])
        XCTAssertEqual(result1, 19)
        let result2: Int = try await client.invoke(method: "subtract", params: [
            "minuend": 42,
            "subtrahend" : 23,
        ])
        XCTAssertEqual(result2, 19)
    }

    func testNotification() async throws {
        await notificationHandler.resetNotifications()

        try await client.notify(method: "update", params: [1, 2, 3, 4])
        let updateNotificationDidHandled = await notificationHandler.updateNotificationDidHandled
        XCTAssertTrue(updateNotificationDidHandled)

        try await client.notify(method: "foobar", params: Parameters.void)
        let foobarNotificationDidHandled = await notificationHandler.foobarNotificationDidHandled
        XCTAssertTrue(foobarNotificationDidHandled)
    }

    func testRpcCallOfNonExistentMethod() async throws {
        do {
            let _: String = try await client.invoke(method: "foobar", params: Parameters.void)
        } catch let error as JsonRpcError {
            XCTAssertEqual(error.code, -32601)
            XCTAssertEqual(error.message, "Method not found")
        }
    }

    func testRpcCallEithAnEmptyArray() async throws {
        do {
            let _ = try await client.performBatch(requests: [])
        } catch let error as JsonRpcError {
            XCTAssertEqual(error.code, -32600)
            XCTAssertEqual(error.message, "Invalid Request")
        }
    }
}

extension JsonRpcServiceMock {
    struct SubtractParams: Decodable {
        let minuend: Int
        let subtrahend: Int
    }

    static func subtract(request: JsonRpc.Request, response: JsonRpc.Response.Builder) async {
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

    static func sum(request: JsonRpc.Request, response: JsonRpc.Response.Builder) async {
        if let numbers = try? request.params([Int].self) {
            let result = numbers.reduce(0, { $0 + $1 })
            response.return(result: result)
        } else {
            response.return(error: -32602, message: "Invalid params")
        }
    }

    static func getData(request: JsonRpc.Request, response: JsonRpc.Response.Builder) async {
        XCTFail("Not yet implemented!")
    }
}
