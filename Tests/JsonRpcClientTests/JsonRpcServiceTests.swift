//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 19.03.2024.
//

import XCTest
@testable import JsonRpcClient
import JsonRpcClientMocks

final class JsonRpcServiceTests: XCTestCase {

    let client = OpenRpcClient(
        endpoint: "/",
        transport: JsonRpcServiceMock(
            implementations: [
                "subtract": JsonRpcServiceMock.subtract(request:response:),
                "sum": JsonRpcServiceMock.sum(request:response:),
                "get_data": JsonRpcServiceMock.getData(request:response:),
            ]
        ).withLogger()
    )

    func testJsonRpcService() async throws {
        let result1: Int = try await client.invoke(method: "subtract", params: [42, 23])
        XCTAssertEqual(result1, 19)
        let result2: Int = try await client.invoke(method: "subtract", params: [23, 42])
        XCTAssertEqual(result2, -19)
        let result3: Int = try await client.invoke(method: "subtract", params: [
            "subtrahend" : 23,
            "minuend": 42,
        ])
        XCTAssertEqual(result3, 19)
        let result4: Int = try await client.invoke(method: "subtract", params: [
            "minuend": 42,
            "subtrahend" : 23,
        ])
        XCTAssertEqual(result4, 19)
        try await client.notify(method: "update", params: [1, 2, 3, 4])
        try await client.notify(method: "foobar", params: Parameters.void)
        do {
            let _: String = try await client.invoke(method: "foobar", params: Parameters.void)
        } catch let error as JsonRpcError {
            XCTAssertEqual(error.code, -32601)
            XCTAssertEqual(error.message, "Method not found")
        }
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
        //
    }

    static func updateNotification(request: JsonRpc.Request) async {
        //
    }

    static func foobarNotification(request: JsonRpc.Request) async {
        //
    }
}
