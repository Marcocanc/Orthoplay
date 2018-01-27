//
//  Track.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public struct Track: Decodable {
    /// The ID of the Track.
    public let id: Int
    /// The artist of the Track.
    public let artist: String
    /// The title of the Track.
    public let title: String
    /// The duration of the Tack.
    public let duration: TimeInterval
    /// The identifier of the Service this track comes from.
    public let serviceId: Int
    /// The index of the Track.
    public let index: Int
    
    public let uid: String
    
    /// The URL of the Track.
    public let url: String // Can't use URL here because this can also be the Spotify URI
    
    
    public let history: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id = "track_id"
        case artist
        case title
        case duration = "duration_ms"
        case serviceId = "service_id"
        case index = "track_index"
        case uid
        case url
        case history
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.title = try container.decode(String.self, forKey: .title)
        self.duration = try container.decode(Double.self, forKey: .duration) / 1000
        self.serviceId = try container.decode(Int.self, forKey: .serviceId)
        self.index = try container.decode(Int.self, forKey: .index)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.url = try container.decode(String.self, forKey: .url)
        self.history = try container.decodeIfPresent(Bool.self, forKey: .history)
    }
}
