//
//  Service.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

/// An external serivce that the OD-11 can access. E.g. Soundcloud or external URL.
struct Service: Decodable {
    let id: Int
    let name: String
    let requiresAuthorization: Bool
    let supportsLinking: Bool
    let supportsScrubbing: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case requiresAuthorization = "requires_authorization"
        case supportsLinking = "supports_liking"
        case supportsScrubbing = "supports_scrubbing"
    }
}
