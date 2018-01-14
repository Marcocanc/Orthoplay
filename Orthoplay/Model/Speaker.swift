//
//  Speaker.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation

public struct Speaker: Decodable {
    public let boxSerial: String
    public let channel: Channel
    public let channelSetting: Channel
    public let channelSwitchState: Channel
    public let configured: Bool
    public let groupId: UUID?
    public let ip: String
    public let lineIn: Bool
    public let mac: String
    public let mcuSerial: String
    public let muted: Bool
    public let numFriends: Int
    public let revision: String
    public let sleepEnable: Bool
    public let ssid: String
    public let toslink: Bool
    public let uuid: UUID
    public let wifiQuality: Int
    public let spotifyUser: String?
    public let spotifyBlob: String?
    
    public enum Channel: String, Codable {
        case right
        case left
        case mono
    }
    
    private enum CodingKeys: String, CodingKey {
        case boxSerial = "box_serial"
        case channel
        case channelSetting = "channel_setting"
        case channelSwitchState = "channel_switch_state"
        case configured
        case groupId = "group_id"
        case ip
        case lineIn = "linein"
        case mac
        case mcuSerial = "mcu_serial"
        case muted
        case numFriends = "num_friends"
        case revision
        case sleepEnable = "sleep_enable"
        case ssid
        case toslink
        case uuid
        case wifiQuality = "wifi_quality"
        case spotifyUser = "spotify_user"
        case spotifyBlob = "spotify_blob"
    }
}
