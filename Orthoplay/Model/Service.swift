//
//  Service.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

/// An external serivce that the OD-11 can access. E.g. Soundcloud or external URL.
public struct Service: Decodable, Equatable, Hashable {
    public let id: Int
    public let name: String
    public let requiresAuthorization: Bool
    public let supportsLiking: Bool
    public let supportsScrubbing: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case requiresAuthorization = "requires_authorization"
        case supportsLiking = "supports_liking"
        case supportsScrubbing = "supports_scrubbing"
    }
    
    public var hashValue: Int {
        return id
    }
    public static func ==(lhs: Service, rhs: Service) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}
