//
//  SourceTests.swift
//  OrthoplayTests
//
//  Created by Marco Cancellieri on 21.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import XCTest
@testable import Orthoplay

class SourceTests: XCTestCase {
    
    func testParsing() {
        let jsonString = """
            {
              "id": 0,
              "name": "AirPlay",
              "supports_jump_to_track_url": false,
              "supports_meta": true,
              "supports_pause": true,
              "supports_seek": false,
              "supports_skip": true,
              "supports_track_position": true
            }
        """
        
        let jsonDecoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)!
        let source = try? jsonDecoder.decode(Source.self, from: data)
        XCTAssertNotNil(source)
        
        XCTAssertEqual(source?.id, 0)
        XCTAssertEqual(source?.name, "AirPlay")
        XCTAssertEqual(source?.capabilities, [.meta, .pause, .skip, .trackPosition])
    }
    
}
