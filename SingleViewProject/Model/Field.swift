//
//  Field.swift
//  SingleViewProject
//
//  Created by Ateeq Ahmed on 08/08/24.
//

import Foundation

struct APIResponse: Codable {
    let status: Bool
    let message: String
    let data: DataClass
    let error: JSONNull?
}

// MARK: - DataClass
struct DataClass: Codable {
    let list: [Field]
}

// MARK: - List
struct Field: Codable {
    let fieldID: String?
    let dataTypeID, sequence: Int?
    let label: String?
    let suggestedValues: [SuggestedValue]?

    enum CodingKeys: String, CodingKey {
        case fieldID
        case dataTypeID = "dataTypeId"
        case sequence, label, suggestedValues
    }
}

// MARK: - SuggestedValue
struct SuggestedValue: Codable {
    let id: Int?
    let title: String?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
