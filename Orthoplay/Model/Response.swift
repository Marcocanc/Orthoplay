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
        let updateIdentifier = try container.decode(ResponseIdentifierKeys.self, forKey: .response)
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
        case response
    }
    
    private enum ResponseIdentifierKeys: String, Decodable {
        case speakerPong = "speaker_pong"
        case groupJoined = "group_joined"
    }
    
}

internal struct ValueWrapper<T: Decodable>: Decodable {
    let value: T
}


public struct GroupJoinedResponse: Decodable {
    public let groupId: String
    public let sid: Int
    public let sources: [Source]
    public let state: [Update]
}


public struct GlobalJoinedResponse: Decodable {
    public let latestRevision: String
    public let mac: String
    public let orthocloudBaseURL: String
    public let palette: Palette
    public let protocolMajorVersion: Int
    public let protocolMinorVersion: Int
    public let services: [Service]
    public let ssid: String
    public let state: [Update]
    
    private enum CodingKeys: String, CodingKey {
        case latestRevision = "latest_revision"
        case mac
        case orthocloudBaseURL = "orthocloud_base_url"
        case palette
        case protocolMajorVersion = "protocol_major_version"
        case protocolMinorVersion = "protocol_minor_version"
        case services
        case ssid
        case state
    }
}



