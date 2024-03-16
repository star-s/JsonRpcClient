//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 06.03.2024.
//

import Foundation

public struct AnyDecodable: Decodable {
    private let decoder: Decoder

    public init(from decoder: Decoder) {
        self.decoder = decoder
    }

    public func value<T: Decodable>(_ type: T.Type = T.self) throws -> T {
        try T.init(from: decoder)
    }
}
