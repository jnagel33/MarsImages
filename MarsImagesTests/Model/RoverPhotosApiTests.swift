//
//  RoverPhotosApiTests.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages
import XCTest

class RoverPhotoApiTests: XCTestCase {
    
    var api: RoverPhotosApiImpl!
    
    var urlDataDownloader: UrlDataDownloaderMock!
    var parser: RoverPhotoJsonParserMock!
    
    let page: UInt = 3
    let json =  ["test": "test"]
    var data: Data {
        return try! JSONSerialization.data(withJSONObject: json, options: [])
    }
    let photo: Photo = {
        let camera = Camera(id: 1, shortName: "short", fullName: "full", roverId: 1)
        let rover = Rover(id: 1, name: "name", status: "active", landingDate: .distantPast, launchDate: Date())
        return Photo(id: 1, url: "url", date: .distantPast, camera: camera, rover: rover)
    }()
    
    override func setUp() {
        super.setUp()
        
        urlDataDownloader = UrlDataDownloaderMock()
        parser = RoverPhotoJsonParserMock()
        
        api = RoverPhotosApiImpl(urlDataDownloader: urlDataDownloader, parser: parser)
    }
    
    func test_fetchPhotos_success() {
        urlDataDownloader.fetchDataResult = .success(data)
        parser.photosResult = [photo]
        
        let expectation = self.expectation(description: "fetchPhotos_success")
        
        api.fetchPhotos(page: page) { result in
            expectation.fulfill()
            
            XCTAssertTrue(self.urlDataDownloader.fetchDataCalled)
            XCTAssertEqual(self.urlDataDownloader.fetchDataUrlArg, "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=3Bs5xtbl8SBw3eHas050hiubtGlq4EOUZXuoOWCp&page=3&sol=100")
            XCTAssertTrue(self.parser.photosCalled)
            XCTAssertEqual(self.parser.photosJsonArg as? [String: String], self.json)
            
            if case .failure(let error) = result {
                XCTFail("Unexpectedly failed to fetch photos with error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_fetchPhotos_fetchFailure() {
        urlDataDownloader.fetchDataResult = .failure(.serverError)
        
        let expectation = self.expectation(description: "fetchPhotos_fetchFailure")
        
        api.fetchPhotos(page: page) { result in
            expectation.fulfill()
            
            XCTAssertTrue(self.urlDataDownloader.fetchDataCalled)
            XCTAssertEqual(self.urlDataDownloader.fetchDataUrlArg, "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=3Bs5xtbl8SBw3eHas050hiubtGlq4EOUZXuoOWCp&page=3&sol=100")
            XCTAssertFalse(self.parser.photosCalled)
            
            switch result {
            case .success:
                XCTFail("Expected to fail")
            case .failure(let error):
                XCTAssertEqual(error, .fetchError(causedBy: .serverError))
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_fetchPhotos_jsonParseFailure() {
        urlDataDownloader.fetchDataResult = .success(data)
        let parseError: RoverPhotoJsonParserError = .failedToParseRoverInfo
        parser.photosError = parseError
        
        let expectation = self.expectation(description: "fetchPhotos_jsonParseFailure")
        
        api.fetchPhotos(page: page) { result in
            expectation.fulfill()
            
            XCTAssertTrue(self.urlDataDownloader.fetchDataCalled)
            XCTAssertEqual(self.urlDataDownloader.fetchDataUrlArg, "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=3Bs5xtbl8SBw3eHas050hiubtGlq4EOUZXuoOWCp&page=3&sol=100")
            XCTAssertTrue(self.parser.photosCalled)
            XCTAssertEqual(self.parser.photosJsonArg as? [String: String], self.json)
            
            switch result {
            case .success:
                XCTFail("Expected to fail")
            case .failure(let error):
                XCTAssertEqual(error, .jsonParseError(causedBy: parseError))
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
