//
//  Message.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 21.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public enum Message: Decodable {
    case update(Update)
    case response(Response)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.response) {
            let response = try Response(from: decoder)
            self = .response(response)
        } else if container.contains(.update) {
            let update = try Update(from: decoder)
            self = .update(update)
        } else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Received an unimplemented Message type from the OD-11")
            throw DecodingError.typeMismatch(Message.self, context)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case update
        case response
    }
}
