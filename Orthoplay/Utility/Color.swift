//
//  Color.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public struct Color: Decodable {
    public let red: Double
    public let green: Double
    public let blue: Double
    public let alpha: Double
    // OD-11 receives colors as integer values.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let integer = try container.decode(Int.self)
        let hex = String(format: "%06x", integer) // Format as HEX string with left 0-padding
        // Adapted from https://gist.github.com/benhurott/d0ec9b3eac25b6325db32b8669196140
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
        self.red = Double(r) / 255
        self.green = Double(g) / 255
        self.blue = Double(b) / 255
        self.alpha = Double(a) / 255
    }
}

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
    fileprivate typealias _Color = UIColor
    public extension Color {
        /// UIColor representation of self
        public var uiColor: UIColor {
            return UIColor(color: self)
        }
    }
#elseif os(OSX)
    import AppKit
    fileprivate typealias _Color = NSColor
    public extension Color {
        /// NSColor representation of self
        public var nsColor: NSColor {
            return _Color(color: self)
        }
    }
#endif

extension _Color {
    convenience init(color: Color) {
        self.init(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
    }
}
