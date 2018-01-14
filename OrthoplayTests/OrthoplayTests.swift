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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
