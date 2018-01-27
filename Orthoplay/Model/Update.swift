//
//  Updates.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public enum Update: Decodable {
    case speakerAdded(Updates.SpeakerAdded)
    case speakerGroup(Group)
    case groupVolumeChanged(Updates.VolumeChange)
    case realtime(Updates.Realtime)
    case groupMasterChanged(Updates.GroupMasterChanged)
    case clientConnected(Updates.ClientConnected)
    case playbackStateChanged(Updates.PlaybackStateChanged)
    
    case groupEqMidBoost(Updates.EnabledToggle)
    case groupEqBassBoost(Updates.EnabledToggle)
    case groupEqTrebleBoost(Updates.EnabledToggle)
    case clientJoinedGroup(Updates.ClientJoinedGroup)
    
    case groupMaxVolume(Int)
    
    case groupInputSourceChanged(Updates.InputSourceChanged)
    
    case listChanged(Updates.ListChanged)
    
    case trackChanged(Updates.TrackChanged)
    case trackChangedByClient(Updates.TrackChangedByClient)
    case clientLeftGroup(Updates.ClientLeftGroup)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let updateIdentifier = try container.decode(UpdateIdentifierKeys.self, forKey: .update)
        
        switch updateIdentifier {
        case .playbackStateChanged:
            self = .playbackStateChanged(try Updates.PlaybackStateChanged(from: decoder))
        case .speakerAdded:
            self = .speakerAdded(try Updates.SpeakerAdded(from: decoder))
        case .speakerGroup:
            self = .speakerGroup(try Group(from: decoder))
        case .groupVolumeChanged:
            self = .groupVolumeChanged(try Updates.VolumeChange(from: decoder))
        case .realtime:
            self = .realtime(try Updates.Realtime(from: decoder))
        case .groupMasterChanged:
            self = .groupMasterChanged(try Updates.GroupMasterChanged(from: decoder))
        case .clientConnected:
            self = .clientConnected(try Updates.ClientConnected(from: decoder))
        // EQ
        case .groupEqBassBoost:
            self = .groupEqBassBoost(try Updates.EnabledToggle(from: decoder))
        case .groupEqMidBoost:
            self = .groupEqMidBoost(try Updates.EnabledToggle(from: decoder))
        case .groupEqTrebleBoost:
            self = .groupEqTrebleBoost(try Updates.EnabledToggle(from: decoder))
        //
        case .groupMaxVolume:
            self = .groupMaxVolume(try ValueWrapper<Int>(from: decoder).value)
        case .groupInputSourceChanged:
            self = .groupInputSourceChanged(try Updates.InputSourceChanged(from: decoder))
        case .clientJoinedGroup:
            self = .clientJoinedGroup(try Updates.ClientJoinedGroup(from: decoder))
        case .listChanged:
            self = .listChanged(try Updates.ListChanged(from: decoder))
        case .trackChanged:
            self = .trackChanged(try Updates.TrackChanged(from: decoder))
        case .trackChangedByClient:
            self = .trackChangedByClient(try Updates.TrackChangedByClient(from: decoder))
        case .clientLeftGroup:
            self = .clientLeftGroup(try Updates.ClientLeftGroup(from: decoder))
        }
        
        // Input
        
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case update
    }
    
    private enum UpdateIdentifierKeys: String, Decodable {
        case playbackStateChanged = "playback_state_changed"
        case speakerAdded = "speaker_added"
        case speakerGroup = "speaker_group"
        
        case clientConnected = "client_connected"
        case clientLeftGroup = "client_left_group"
        case realtime
        
        case listChanged = "list_changed"
        
        case clientJoinedGroup = "client_joined_group"
        
        case groupMaxVolume = "group_max_volume"
        case groupVolumeChanged = "group_volume_changed"
        case groupMasterChanged = "group_master_changed"
        
        case groupEqMidBoost = "group_eq_mid_boost"
        case groupEqBassBoost = "group_eq_bass_boost"
        case groupEqTrebleBoost = "group_eq_treble_boost"
        
        case groupInputSourceChanged = "group_input_source_changed"
        case trackChanged = "track_changed"
        case trackChangedByClient = "track_changed_by_client"
    }
}


public enum ListType: String, Decodable {
    case playlist
}

public struct Updates {
    
    public struct ClientLeftGroup: Decodable {
        public let sid: Int
    }
    public struct SpeakerGroup: Decodable {
        public let id: String
        
    }
    public struct TrackChanged: Decodable {
        public let track: Track
    }
    public struct TrackChangedByClient: Decodable {
        public let sid: Int
        public let direction: Int
        public let track: Track
    }
    
    public struct ListChanged: Decodable {
        public let listRevision: Int
        public let listType: ListType
        public let newSize: Int
        public let oldSize: Int
        public let startIndex: Int
        
        private enum CodingKeys: String, CodingKey {
            case listRevision = "list_revision"
            case listType = "list_type"
            case newSize = "new_size"
            case oldSize = "old_size"
            case startIndex = "start_index"
        }
    }
    
    public struct ClientJoinedGroup: Decodable {
        public let client: Client
    }
    
    public struct InputSourceChanged: Decodable {
        public let source: Int
        public let sid: Int
        public let directMode: Bool
        
        private enum CodingKeys: String, CodingKey {
            case directMode = "direct_mode"
            case source
            case sid
        }
    }
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
    
    
    public struct EnabledToggle: Decodable {
        public let sid: Int
        public let enabled: Bool
    }
    
    public struct PlaybackStateChanged: Decodable {
        public let playing: Bool
        public let sid: Int
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
