//
//  MessageTests.swift
//  OrthoplayTests
//
//  Created by Marco Cancellieri on 21.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import XCTest
@testable import Orthoplay

class MessageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testResponse() {
        let jsonString = """
            { "response" : "speaker_pong", "value" : 810549 }
        """
        
        let jsonDecoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)!
        let message = try? jsonDecoder.decode(Message.self, from: data)
        XCTAssertNotNil(message)
        guard let msg = message, case .response = msg else {
            return XCTFail("didn't parse response")
        }
    }
    
    func testUpdate() {
        let jsonString = """
            { "sid" : 37, "update" : "group_volume_changed", "vol" : 30 }
        """
        
        let jsonDecoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)!
        let message = try? jsonDecoder.decode(Message.self, from: data)
        XCTAssertNotNil(message)
        guard let msg = message, case .update = msg else {
            return XCTFail("didn't parse update")
        }
    }
    
    func testError() {
        let jsonString = """
            { "foo" : 37 }
        """
        
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)!
        XCTAssertThrowsError(try decoder.decode(Message.self, from: data)) { error in
            guard let err = error as? DecodingError, case .typeMismatch(let type, _) = err else {
                XCTFail("wrong error type")
                return
            }
            XCTAssert(type == Message.self)
        }
    }
}

