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
    case groupJoined(GroupJoinedResponse)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let updateIdentifier = try container.decode(ResponseIdentifier.self, forKey: .update)
        switch updateIdentifier {
        case .speakerPong:
            let valueWrapped = try ValueWrapper<Int>(from: decoder)
            self = .speakerPong(valueWrapped.value)
        case .groupJoined:
            let resp = try GroupJoinedResponse(from: decoder)
            self = .groupJoined(resp)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case update
    }
    
    private enum ResponseIdentifier: String, Decodable {
        case speakerPong = "speaker_pong"
        case groupJoined = "group_joined"
    }
    
}

internal struct ValueWrapper<T: Decodable>: Decodable {
    let value: T
}


public struct GroupJoinedResponse: Decodable {
    public let groupId: String
    public let sid: String
    public let sources: [Source]
    public let state: [Update]
}


public struct GlobalJoinedResponse: Decodable {
    public let latestRevision: String
    public let mac: String
    public let palette: Palette
    public let protocolMajorVersion: Int
    public let protocolMinorVersion: Int
    public let services: [Service]
    public let ssid: String
    public let sate: [Update]
}


public struct Palette: Decodable {
    public let name: String
    public let backgroundColors: [Color]
    public let foregroundColors: [Color]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case backgroundColors = "bg_colors"
        case foregroundColors = "fg_colors"
    }
}
