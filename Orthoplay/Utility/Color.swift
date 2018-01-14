//
//  Color.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation
import UIKit

public struct Color: Decodable {
    public let red: CGFloat
    public let green: CGFloat
    public let blue: CGFloat
    public let alpha: CGFloat
    // OD-11 receives colors as integer values.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let integer = try container.decode(Int.self)
        // Adapted from https://gist.github.com/benhurott/d0ec9b3eac25b6325db32b8669196140
        let hex = String(format: "%06x", integer) // Format as HEX string with left 0-padding
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.red = CGFloat(r) / 255
        self.green = CGFloat(g) / 255
        self.blue = CGFloat(b) / 255
        self.alpha = CGFloat(a) / 255
    }
    
    public var uiColor: UIColor {
        return UIColor(color: self)
    }
}

public extension UIColor {
    public convenience init(color: Color) {
        self.init(red: color.red, green: color.green, blue: color.blue, alpha: color.alpha)
    }
}

