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
    case groupVolumeChanged(VolumeChangeUpdate)
    case realtime(RealtimeUpdate)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let updateIdentifier = try container.decode(UpdateIdentifierKeys.self, forKey: .update)
        
        switch updateIdentifier {
        case .speakerAdded:
            let speaker = try SpeakerUpdate(from: decoder)
            self = .speakerAdded(speaker.speaker)
        case .speakerGroup:
            let group = try Group(from: decoder)
            self = .speakerGroup(group)
        case .groupVolumeChanged:
            let volUpdate = try VolumeChangeUpdate(from: decoder)
            self = .groupVolumeChanged(volUpdate)
        case .realtime:
            let realtimeUpdate = try RealtimeUpdate(from: decoder)
            self = .realtime(realtimeUpdate)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case update
    }
    
    private enum UpdateIdentifierKeys: String, Decodable {
        case speakerAdded = "speaker_added"
        case speakerGroup = "speaker_group"
        case groupVolumeChanged = "group_volume_changed"
        case realtime
    }
}


public struct RealtimeUpdate: Decodable {
    public let bufferStart: Int
    public let bufferEnd: Int
    public let position: Double
    
    private enum CodingKeys: String, CodingKey {
        case bufferStart = "buf_start"
        case bufferEnd = "buf_end"
        case position
    }
}


public struct VolumeChangeUpdate: Decodable {
    public let volume: Int
    public let sid: Int
    
    private enum CodingKeys: String, CodingKey {
        case volume = "vol"
        case sid
    }
}

internal struct SpeakerUpdate: Decodable {
    let speaker: Speaker
}

