//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 19.03.2024.
//

import XCTest
import HttpClientUtilities
@testable import JsonRpcClient

final class RpcCallTests: XCTestCase {

    private lazy var client = OpenRpcClient(
        endpoint: "/",
        transport: testService.withLogger()
    )

    private let testService = TestService()

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
        await testService.resetNotifications()

        try await client.notify(method: "update", params: [1, 2, 3, 4])
        let updateNotificationDidHandled = await testService.updateNotificationDidHandled
        XCTAssertTrue(updateNotificationDidHandled)

        try await client.notify(method: "foobar", params: Parameters.void)
        let foobarNotificationDidHandled = await testService.foobarNotificationDidHandled
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
            _ = try await client.performBatch(request: [])
        } catch let error as JsonRpcError {
            XCTAssertEqual(error.code, -32600)
            XCTAssertEqual(error.message, "Invalid Request")
        }
    }

    func testRpcCallBatch() async throws {
        let responses = try await client.performBatch(request: [
            .invocation(method: "sum", params: [1,2,4], id: .number(1)),
            .notification(method: "notify_hello", params: [7]),
            .invocation(method: "subtract", params: [42,23], id: .number(2)),
            .invocation(method: "foo.get", params: ["name": "myself"], id: .number(5)),
            .invocation(method: "get_data", params: Parameters.void, id: .number(9)),
        ])
        XCTAssertEqual(responses.count, 4)

        let sumResult = try responses.item(id: 1)?.result(Int.self)
        XCTAssertEqual(sumResult, 7)

        let subtractResult = try responses.item(id: 2)?.result(Int.self)
        XCTAssertEqual(subtractResult, 19)

        let error = try XCTUnwrap(responses.item(id: 5)?.error())
        XCTAssertEqual(error.code, -32601)
        XCTAssertEqual(error.message, "Method not found")

        let getGataResult = try XCTUnwrap(responses.item(id: 9)?.result([String].self))
        XCTAssertEqual(getGataResult.count, 2)
        XCTAssertTrue(getGataResult.contains("hello"))
        XCTAssertTrue(getGataResult.contains("5"))
    }

    func testRpcCallBatchAllNotifications() async throws {
        let result = try await client.performBatch(request: [
            .notification(method: "notify_sum", params: [1,2,4]),
            .notification(method: "notify_hello", params: [7]),
        ])
        XCTAssertTrue(result.isEmpty)
    }
}
