//
//  Source.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public struct Source: Decodable {
    public let id: Int
    public let name: String
    public let capabilities: Set<Capability>
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        let capContainer = try decoder.container(keyedBy: Capability.self)
        self.capabilities = try Capability.allCapabilities.filter { try capContainer.decode(Bool.self, forKey: $0) }
    }
    
    public enum Capability: String, CodingKey {
        case jumpToTrackURL = "supports_jump_to_track_url"
        case meta = "supports_meta"
        case pause = "supports_pause"
        case seek = "supports_seek"
        case skip = "supports_skip"
        case trackPosition = "supports_track_position"
        
        static var allCapabilities: Set<Capability> {
            return [.jumpToTrackURL, .meta, .pause, .seek, .skip, .trackPosition]
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
