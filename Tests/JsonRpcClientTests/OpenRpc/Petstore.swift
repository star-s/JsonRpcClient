//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.02.2024.
//

import XCTest
import JsonRpcClient

// https://raw.githubusercontent.com/open-rpc/examples/master/service-descriptions/petstore-openrpc.json

protocol PetstoreApi {
    func listPets(limit: Int) async throws -> [Pet]
    func createPet(name: String, tag: String?) async throws -> Int
    func getPet(id: Int) async throws -> Pet
}

struct Pet: Decodable {
    let id: Int
    let name: String
    let tag: String?
}

// MARK: - Implementation

extension PetstoreApi where Self: JsonRpcClient {
    func listPets(limit: Int) async throws -> [Pet] {
        try await invoke(method: "list_pets", params: [limit])
    }

    func createPet(name: String, tag: String?) async throws -> Int {
        try await invoke(method: "create_pet", params: CreatePetRequest(newPetName: name, newPetTag: tag))
    }

    func getPet(id: Int) async throws -> Pet {
        try await invoke(method: "get_pet", params: ["petId": id])
    }
}

struct CreatePetRequest: Encodable {
    let newPetName: String
    let newPetTag: String?
}

extension OpenRpcClient: PetstoreApi {}

final class PetstoreTests: XCTestCase {

    let petstore: PetstoreApi = OpenRpcClient(endpoint: "petstore-1.0.0")

    func testListPets() async throws {
        let result = try await petstore.listPets(limit: 20)
        XCTAssertFalse(result.isEmpty)
    }

    func testCreatePet() async throws {
        let id = try await petstore.createPet(name: "fluffy", tag: "poodle")
        XCTAssertNotEqual(id, 0)
    }

    func testGetPet() async throws {
        let result = try await petstore.getPet(id: 7)
        XCTAssertEqual(result.id, 7)
    }
}
