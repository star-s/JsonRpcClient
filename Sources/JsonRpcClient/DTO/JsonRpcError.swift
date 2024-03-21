//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public struct JsonRpcError {
	public let code: Int
	public let message: String

    public var hasData: Bool {
        container.contains(.data)
    }

	private let container: KeyedDecodingContainer<CodingKeys>

    public init(code: Int, message: String) {
        self.code = code
        self.message = message
        self.container = [:]
    }

    public init<T: Decodable>(code: Int, message: String, data: T?) {
        self.code = code
        self.message = message
        if let data {
            self.container = [
                .data: data
            ]
        } else {
            self.container = [:]
        }
    }

	public func data<T: Decodable>(_ type: T.Type = T.self) throws -> T {
		try container.decode(type, forKey: .data)
	}
}

extension JsonRpcError: Decodable {
	
	private enum CodingKeys: String, CodingKey {
		case code
		case message
		case data
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.code = try container.decode(Int.self, forKey: .code)
		self.message = try container.decode(String.self, forKey: .message)
		self.container = container
	}
}

extension JsonRpcError: LocalizedError {
	public var errorDescription: String? { message }
}
