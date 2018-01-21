//
//  Updates.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public enum Update: Decodable {
    case speakerAdded(Speaker)
    case speakerGroup(Group)
    case groupVolumeChanged(Updates.VolumeChange)
    case realtime(Updates.Realtime)
    case groupMasterChanged(Updates.GroupMasterChanged)
    case clientConnected(Updates.ClientConnected)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let updateIdentifier = try container.decode(UpdateIdentifierKeys.self, forKey: .update)
        
        switch updateIdentifier {
        case .speakerAdded:
            let speaker = try Updates.SpeakerAdded(from: decoder)
            self = .speakerAdded(speaker.speaker)
        case .speakerGroup:
            let group = try Group(from: decoder)
            self = .speakerGroup(group)
        case .groupVolumeChanged:
            let volUpdate = try Updates.VolumeChange(from: decoder)
            self = .groupVolumeChanged(volUpdate)
        case .realtime:
            let realtimeUpdate = try Updates.Realtime(from: decoder)
            self = .realtime(realtimeUpdate)
        case .groupMasterChanged:
            let update = try Updates.GroupMasterChanged(from: decoder)
            self = .groupMasterChanged(update)
        case .clientConnected:
            let update = try Updates.ClientConnected(from: decoder)
            self = .clientConnected(update)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case update
    }
    
    private enum UpdateIdentifierKeys: String, Decodable {
        case speakerAdded = "speaker_added"
        case speakerGroup = "speaker_group"
        case groupVolumeChanged = "group_volume_changed"
        case clientConnected = "client_connected"
        case groupMasterChanged = "group_master_changed"
        case realtime
    }
}


public struct Updates {
    public struct Realtime: Decodable {
        public let bufferStart: Int
        public let bufferEnd: Int
        public let position: Double
        
        private enum CodingKeys: String, CodingKey {
            case bufferStart = "buf_start"
            case bufferEnd = "buf_end"
            case position
        }
    }
    
    
    public struct VolumeChange: Decodable {
        public let volume: Int
        public let sid: Int
        
        private enum CodingKeys: String, CodingKey {
            case volume = "vol"
            case sid
        }
    }
    
    public struct SpeakerAdded: Decodable {
        public let speaker: Speaker
    }

    public struct GroupMasterChanged: Decodable {
        public let masterIP: String
        
        private enum CodingKeys: String, CodingKey {
            case masterIP = "master_ip"
        }
    }
    
    public struct ClientConnected: Decodable {
        let sid: Int
        let connected: Bool
    }
}
