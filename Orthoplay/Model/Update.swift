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
    case groupVolumeChanged
    case realtime(RealtimeUpdate)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let updateIdentifier = try container.decode(UpdateIdentifier.self, forKey: .update)
        
        switch updateIdentifier {
        case .speakerAdded:
            let speaker = try SpeakerUpdate(from: decoder)
            self = .speakerAdded(speaker.speaker)
        case .speakerGroup:
            let group = try Group(from: decoder)
            self = .speakerGroup(group)
        case .realtime:
            let realtimeUpdate = try RealtimeUpdate(from: decoder)
            self = .realtime(realtimeUpdate)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case update
        case speaker
    }
    
    private enum UpdateIdentifier: String, Decodable {
        case speakerAdded = "speaker_added"
        case speakerGroup = "speaker_group"
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

internal struct SpeakerUpdate: Decodable {
    let speaker: Speaker
}

