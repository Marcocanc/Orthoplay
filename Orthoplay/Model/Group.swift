//
//  Group.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public struct Group: Decodable, Equatable, Hashable {
    public let id: String
    public let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "group_id"
        case name = "group_name"
    }
    
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func ==(lhs: Group, rhs: Group) -> Bool {
        return lhs.checkIfEqualTo(rhs, byComparing: \.id, \.name)
    }
}

extension Equatable {
    func checkIfEqualTo<T: Equatable>(_ other: Self, byComparing paths: KeyPath<Self,T>...) -> Bool {
        for keyPath in paths {
            guard self[keyPath: keyPath] == other[keyPath: keyPath] else {
                return false
            }
        }
        return true
    }
    
}

