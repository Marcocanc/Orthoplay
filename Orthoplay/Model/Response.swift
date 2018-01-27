//
//  Response.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public enum Response: Decodable {
    case speakerPong(Responses.SpeakerPong)
    case globalJoined(Responses.GlobalJoined)
    case groupJoined(Responses.GroupJoined)
    case playlistTracks(Responses.PlaylistTracks)
    case clientInfo(Responses.ClientInfo)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let updateIdentifier = try container.decode(ResponseIdentifierKeys.self, forKey: .response)
        switch updateIdentifier {
        case .speakerPong:
            let resp = try Responses.SpeakerPong(from: decoder)
            self = .speakerPong(resp)
        case .groupJoined:
            let resp = try Responses.GroupJoined(from: decoder)
            self = .groupJoined(resp)
        case .globalJoined:
            let resp = try Responses.GlobalJoined(from: decoder)
            self = .globalJoined(resp)
        case .playlistTracks:
            let resp = try Responses.PlaylistTracks(from: decoder)
            self = .playlistTracks(resp)
        case .clientInfo:
            let resp = try Responses.ClientInfo(from: decoder)
            self = .clientInfo(resp)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case response
    }
    
    private enum ResponseIdentifierKeys: String, Decodable {
        case speakerPong = "speaker_pong"
        case groupJoined = "group_joined"
        case globalJoined = "global_joined"
        case playlistTracks = "playlist_tracks"
        case clientInfo = "client_info"
    }
    
}


public struct Responses {
    
    public struct SpeakerPong: Decodable {
        public let value: Int
    }
    
    public struct ClientInfo: Decodable {
        public let client: Client
    }
    public struct PlaylistTracks: Decodable {
        public let tracks: [Track]
        public let listRevision: Int
        
        private enum CodingKeys: String, CodingKey {
            case tracks
            case listRevision = "list_revision"
        }
    }
    public struct GroupJoined: Decodable {
        public let groupId: String
        public let sid: Int
        public let sources: [Source]
        public let state: [Update]
        
        private enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case sid
            case sources
            case state
        }
    }
    
    
    public struct GlobalJoined: Decodable {
        public let latestRevision: String
        public let mac: String
        public let orthocloudBaseURL: String
        public let palette: Palette
        public let protocolMajorVersion: Int
        public let protocolMinorVersion: Int
        public let services: Set<Service>
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
}

internal struct ValueWrapper<T: Decodable>: Decodable {
    let value: T
}






