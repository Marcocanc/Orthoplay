//
//  Response.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public enum Response: Decodable {
    case speakerPong(Int)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let updateIdentifier = try container.decode(ResponseIdentifier.self, forKey: .update)
        switch updateIdentifier {
        case .speakerPong:
            let valueWrapped = try ValueWrapper<Int>(from: decoder)
            self = .speakerPong(valueWrapped.value)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case update
    }
    
    private enum ResponseIdentifier: String, Decodable {
        case speakerPong = "speaker_pong"
    }
    
}

internal struct ValueWrapper<T: Decodable>: Decodable {
    let value: T
}
