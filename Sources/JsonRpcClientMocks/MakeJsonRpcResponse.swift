//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 18.03.2024.
//

import Foundation
import CoreServices
import HttpClientMocks
import HttpClientUtilities

public func makeJsonRpcResponse(
    for request: URLRequest,
    decoder: JSONDecoder = JSONDecoder(),
    encoder: JSONEncoder = JSONEncoder(),
    _ closure: (JsonRpc.Response.Builder) -> Void
) throws -> (data: Data, response: URLResponse) {
    guard case .single(let rpcRequesr) = try request.decodeJsonRpcRequest(decoder: decoder) else {
        return try handleURLRequest(request) {
            try TaggedData.jsonEncoded(JsonRpc.Response.error(error: -32700, message: "Parse error"), encoder: encoder)
        }
    }
    let builder = JsonRpc.Response.Builder(id: rpcRequesr.id)
    closure(builder)
    return try handleURLRequest(request) {
        guard let response = builder.response else {
            return Data().tag(as: kUTTypeJSON)
        }
        return try TaggedData.jsonEncoded(response, encoder: encoder)
    }
}
