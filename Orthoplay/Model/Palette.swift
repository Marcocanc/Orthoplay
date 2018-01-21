//
//  Palette.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public struct Palette: Decodable {
    public let name: String
    public let colors: [(foreground: Color, background: Color)]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        let foregroundColors = try container.decode([Color].self, forKey: .foregroundColors)
        let backgroundColors = try container.decode([Color].self, forKey: .backgroundColors)
        self.colors = zip(foregroundColors, backgroundColors).map { ($0, $1) }
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case backgroundColors = "bg_colors"
        case foregroundColors = "fg_colors"
    }
}
