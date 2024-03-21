//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.02.2024.
//

import Foundation
import JsonRpcClient
import HttpClient
import HttpClientUtilities

extension URL {
    static let openRpcBaseURL: URL = "https://mock.open-rpc.org"
}

struct OpenRpcClient: HttpClientWithBaseURL, JsonRpcClientImplementation {

    let requestEncoder = JsonRequestEncoder()
    let responseDecoder = JsonRpcResponseDecoder() {
        try $0.asHTTPURLResponse().checkHttpStatusCode()
    }

    let transport: AnyTransport

    let baseURL: URL
    let endpoint: String

    init<T: TransportLayer>(
        baseURL: URL = .openRpcBaseURL,
        endpoint: String,
        transport: T = URLSession.shared.withLogger()
    ) {
        self.baseURL = baseURL
        self.endpoint = endpoint
        self.transport = transport.eraseToAnyTransport()
    }
}
