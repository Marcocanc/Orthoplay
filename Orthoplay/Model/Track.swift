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
}
