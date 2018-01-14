//
//  Client.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public struct Client: Decodable {
    public let colorIndex: Int
    public let connected: Bool
    public let name: String
    public let serial: String
    public let sid: Int
    public let uid: String
    
    private enum CodingKeys: String, CodingKey {
        case colorIndex = "color_index"
        case connected
        case name
        case serial
        case sid
        case uid
    }
}
