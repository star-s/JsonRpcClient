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
    _ closure: (JsonRpcResponseBuilder) -> Void
) throws -> (data: Data, response: URLResponse) {
    try handleURLRequest(request) {
        let builder = try JsonRpcResponseBuilder(id: request.jsonRpcRequest(decoder: decoder).id)
        closure(builder)
        guard let response = builder.response else {
            return Data().tag(as: kUTTypeJSON)
        }
        return try TaggedData.jsonEncoded(response, encoder: encoder)
    }
}
