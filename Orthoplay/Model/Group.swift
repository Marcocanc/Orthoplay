//
//  Group.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public struct Group: Decodable {
    public let id: UUID
    public let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "group_id"
        case name = "group_name"
    }
}


