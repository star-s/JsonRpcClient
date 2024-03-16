//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 02.02.2024.
//

import Foundation

public enum JsonRpcId {
	case string(String)
	case number(Int)
	case null
}

public extension JsonRpcId {
	var string: String? {
		guard case .string(let string) = self else {
			return nil
		}
		return string
	}

	var number: Int? {
		guard case .number(let int) = self else {
			return nil
		}
		return int
	}
}

extension JsonRpcId: Encodable {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .string(let value):
			try container.encode(value)
		case .number(let value):
			try container.encode(value)
		case .null:
			try container.encodeNil()
		}
	}
}

extension JsonRpcId: Decodable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		if container.decodeNil() {
			self = .null
			return
		}
		if let string = try? container.decode(String.self) {
			self = .string(string)
			return
		}
		if let number = try? container.decode(Int.self) {
			self = .number(number)
			return
		}
		throw DecodingError.dataCorruptedError(
			in: container,
			debugDescription: "Must be a String, Number, or NULL value"
		)
	}
}

extension JsonRpcId: ExpressibleByStringLiteral {
	public init(stringLiteral value: String) {
		self = .string(value)
	}
}

extension JsonRpcId: ExpressibleByIntegerLiteral {
	public init(integerLiteral value: Int) {
		self = .number(value)
	}
}

extension JsonRpcId: ExpressibleByNilLiteral {
	public init(nilLiteral: ()) {
		self = .null
	}
}
