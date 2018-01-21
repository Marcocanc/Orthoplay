//
//  OrthoplayTests.swift
//  OrthoplayTests
//
//  Created by Marco Cancellieri on 14.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import XCTest
@testable import Orthoplay

class OrthoplayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPalette() {
        let paletteJSON = """
            {
                "bg_colors" : [
                    935022,
                    18479,
                    15158809,
                    11414311,
                    1117971,
                    5000268,
                    16427286,
                    16448250
                ],
                "fg_colors" : [
                    1644825,
                    1644825,
                    1644825,
                    1644825,
                    13224393,
                    16427286,
                    1644825,
                    1644825
                ],
                "name" : "orthocolors"
            }
        """
        
        let jsonDecoder = JSONDecoder()
        
        let data = paletteJSON.data(using: .utf8)!
        let palette = try? jsonDecoder.decode(Palette.self, from: data)
        XCTAssertNotNil(palette)
        XCTAssertEqual(palette?.colors.count, 8)
        XCTAssertEqual(palette?.name, "orthocolors")
    }
    
    func testGlobalJoin() {
        let jsonString = """
            { "latest_revision" : "0.9.18", "mac" : "544a1x279dxx", "orthocloud_base_url" : "", "palette" : { "bg_colors" : [ 935022, 18479, 15158809, 11414311, 1117971, 5000268, 16427286, 16448250 ], "fg_colors" : [ 1644825, 1644825, 1644825, 1644825, 13224393, 16427286, 1644825, 1644825 ], "name" : "orthocolors" }, "protocol_major_version" : 0, "protocol_minor_version" : 4, "response" : "global_joined", "services" : [ { "id" : 2, "name" : "Soundcloud", "requires_authorization" : true, "supports_liking" : false, "supports_scrubbing" : false }, { "id" : 4, "name" : "General URL", "requires_authorization" : false, "supports_liking" : false, "supports_scrubbing" : false } ], "ssid" : "h3h3_5G", "state" : [ { "group_id" : "04e7cdb0-834c-4c02-8e05-5de133159ced", "group_name" : "OD-11", "update" : "speaker_group" }, { "speaker" : { "box_serial" : "Z4BCH4VF", "channel" : "right", "channel_setting" : "left", "channel_switch_state" : "right", "configured" : false, "group_id" : "04e7cdb0-834c-4c0f-8e05-5de133159ced", "ip" : "192.168.1.103", "linein" : false, "mac" : "544a16279dac", "mcu_serial" : "3333-33333", "muted" : false, "num_friends" : 1, "revision" : "0.9.18", "sleep_enable" : true, "ssid" : "h3h3_5G", "toslink" : false, "uuid" : "1529d55e-339e-431a-befb-68f98283e523", "wifi_quality" : 44 }, "update" : "speaker_added" }, { "speaker" : { "box_serial" : "Z4BCF43H", "channel" : "left", "channel_setting" : "left", "channel_switch_state" : "mono", "configured" : true, "group_id" : "04e7cdb0-834c-4f02-8e05-5de133159ced", "ip" : "192.168.1.111", "linein" : false, "mac" : "544a16278ff7", "mcu_serial" : "3333-333333", "muted" : false, "num_friends" : 1, "revision" : "0.9.18", "sleep_enable" : true, "ssid" : "h3h3_5G", "toslink" : false, "uuid" : "f3585b63-b59e-486b-933b-6368da3b4683", "wifi_quality" : 42 }, "update" : "speaker_added" } ] }
        """
        let jsonDecoder = JSONDecoder()
        
        let data = jsonString.data(using: .utf8)!
        let resp = try? jsonDecoder.decode(Response.self, from: data)
        XCTAssertNotNil(resp)
    }
}
