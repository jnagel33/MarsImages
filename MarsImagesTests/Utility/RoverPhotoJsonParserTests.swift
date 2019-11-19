//
//  RoverPhotoJsonParserTests.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import XCTest
@testable import MarsImages

class RoverPhotoJsonParserTest: XCTestCase {
    
    var parser: RoverPhotoJsonParserImpl!
    
    override func setUp() {
        super.setUp()
        
        parser = RoverPhotoJsonParserImpl()
    }
    
    func test_validJson_success() {
        let json = ["photos":[
                ["id": 1, "sol": 100, "img_src": "http://mars.jpl.nasa.gov/msl-raw-images/msss/00100/mcam/0100MR0005430130104436I01_DXXX.jpg", "earth_date": "2012-11-16", "camera": ["id": 1, "name": "short", "rover_id": 1, "full_name": "full"], "rover": ["id": 1, "name": "rover", "status": "active", "launch_date": "2012-11-16", "landing_date": "2012-11-16"]],
                ["id": 2, "sol": 100, "img_src": "http://mars.jpl.nasa.gov/msl-raw-images/msss/00100/mcam/0100MR0005430130104436I01_DXXX.jpg", "earth_date": "2012-11-16", "camera": ["id": 2, "name": "short", "rover_id": 2, "full_name": "full"], "rover": ["id": 2, "name": "rover", "status": "active", "launch_date": "2012-11-16", "landing_date": "2012-11-16"]]
            ]]
        
        do {
            let photos = try parser.photos(from: json)
            XCTAssertEqual(photos.count, 2)
        } catch {
            XCTFail("Unexpectedly failed to parse json with error: \(error)")
        }
    }
    
    func test_invalidFormat_failure() {
        let json = ["invalid": "test"]
        
        do {
            _ = try parser.photos(from: json)
            XCTFail("Expected to fail")
        } catch {
            XCTAssertEqual(error as? RoverPhotoJsonParserError, .unexpectedJSONFormat)
        }
    }
    
    func test_photoParseError_failure() {
        let json = ["photos":[
                ["notId": 1, "sol": 100, "img_src": "http://mars.jpl.nasa.gov/msl-raw-images/msss/00100/mcam/0100MR0005430130104436I01_DXXX.jpg", "earth_date": "2012-11-16", "camera": ["id": 1, "name": "short", "rover_id": 1, "full_name": "full"], "rover": ["id": 1, "name": "rover", "status": "active", "launch_date": "2012-11-16", "landing_date": "2012-11-16"]],
                ["id": 2, "sol": 100, "img_src": "http://mars.jpl.nasa.gov/msl-raw-images/msss/00100/mcam/0100MR0005430130104436I01_DXXX.jpg", "earth_date": "2012-11-16", "camera": ["id": 2, "name": "short", "rover_id": 2, "full_name": "full"], "rover": ["id": 2, "name": "rover", "status": "active", "launch_date": "2012-11-16", "landing_date": "2012-11-16"]]
            ]]
        
        do {
            _ = try parser.photos(from: json)
            XCTFail("Expected to fail")
        } catch {
            XCTAssertEqual(error as? RoverPhotoJsonParserError, .failedToParsePhotoInfo)
        }
    }
    
    func test_cameraParseError_failure() {
        let json = ["photos":[
                ["id": 1, "sol": 100, "img_src": "http://mars.jpl.nasa.gov/msl-raw-images/msss/00100/mcam/0100MR0005430130104436I01_DXXX.jpg", "earth_date": "2012-11-16", "camera": ["id": 1, "missingName": "short", "rover_id": 1, "full_name": "full"], "rover": ["id": 1, "name": "rover", "status": "active", "launch_date": "2012-11-16", "landing_date": "2012-11-16"]],
                ["id": 2, "sol": 100, "img_src": "http://mars.jpl.nasa.gov/msl-raw-images/msss/00100/mcam/0100MR0005430130104436I01_DXXX.jpg", "earth_date": "2012-11-16", "camera": ["id": 2, "name": "short", "rover_id": 2, "full_name": "full"], "rover": ["id": 2, "name": "rover", "status": "active", "launch_date": "2012-11-16", "landing_date": "2012-11-16"]]
            ]]
        
        do {
            _ = try parser.photos(from: json)
            XCTFail("Expected to fail")
        } catch {
            XCTAssertEqual(error as? RoverPhotoJsonParserError, .failedToParseCameraInfo)
        }
    }
    
    func test_roverParseError_failure() {
        let json = ["photos":[
                ["id": 1, "sol": 100, "img_src": "http://mars.jpl.nasa.gov/msl-raw-images/msss/00100/mcam/0100MR0005430130104436I01_DXXX.jpg", "earth_date": "2012-11-16", "camera": ["id": 1, "name": "short", "rover_id": 1, "full_name": "full"], "rover": ["id": 1, "name": "rover", "status": "active", "launch_date": "2012-11-16", "noLandingDate": "2012-11-16"]],
                ["id": 2, "sol": 100, "img_src": "http://mars.jpl.nasa.gov/msl-raw-images/msss/00100/mcam/0100MR0005430130104436I01_DXXX.jpg", "earth_date": "2012-11-16", "camera": ["id": 2, "name": "short", "rover_id": 2, "full_name": "full"], "rover": ["id": 2, "name": "rover", "status": "active", "launch_date": "2012-11-16", "landing_date": "2012-11-16"]]
            ]]
        
        do {
            _ = try parser.photos(from: json)
            XCTFail("Expected to fail")
        } catch {
            XCTAssertEqual(error as? RoverPhotoJsonParserError, .failedToParseRoverInfo)
        }
    }
}
