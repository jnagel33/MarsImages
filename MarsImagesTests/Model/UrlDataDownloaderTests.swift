//
//  UrlDataDownloaderTests.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages
import XCTest

class UrlDataDownloaderTests: XCTestCase {
    
    var downloader: UrlDataDownloaderImpl!
    var session: URLSessionMock!
    
    override func setUp() {
        super.setUp()
        
        session = URLSessionMock()
        downloader = UrlDataDownloaderImpl(urlSession: session)
    }
    
    func test_fetchData_success() {
        let urlString = "www.google.com"
        let url = URL(string: urlString)!
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.dataTaskResult = ("".data(using: .utf8)!, response, nil)
        
        let expectation = self.expectation(description: "fetchData_success")
        
        downloader.fetchData(at: urlString) { result in
            expectation.fulfill()
            
            XCTAssertTrue(self.session.dataTaskCalled)
            XCTAssertEqual(self.session.dataTaskUrlArg, url)
            
            if case .failure(let error) = result {
                XCTFail("Unexpectedly failed fetch data with error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_fetchData_badResponse() {
        let urlString = "www.google.com"
        let url = URL(string: urlString)!
        
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        session.dataTaskResult = ("".data(using: .utf8)!, response, nil)
        
        let expectation = self.expectation(description: "fetchData_badResponse")
        
        downloader.fetchData(at: urlString) { result in
            expectation.fulfill()
            
            XCTAssertTrue(self.session.dataTaskCalled)
            XCTAssertEqual(self.session.dataTaskUrlArg, url)
            
            switch result {
            case .success:
                XCTFail("Expected to fail")
            case .failure(let error):
                XCTAssertEqual(error, .serverError)
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_fetchData_fetchError() {
        let urlString = "www.google.com"
        let url = URL(string: urlString)!
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.dataTaskResult = (nil, response, RoverPhotoJsonParserError.failedToParseRoverInfo)
        
        let expectation = self.expectation(description: "fetchData_fetchError")
        
        downloader.fetchData(at: urlString) { result in
            expectation.fulfill()
            
            XCTAssertTrue(self.session.dataTaskCalled)
            XCTAssertEqual(self.session.dataTaskUrlArg, url)
            
            switch result {
            case .success:
                XCTFail("Expected to fail")
            case .failure(let error):
                XCTAssertTrue(error.isFetchError)
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_fetchData_noData() {
        let urlString = "www.google.com"
        let url = URL(string: urlString)!
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.dataTaskResult = (nil, response, nil)
        
        let expectation = self.expectation(description: "fetchData_noData")
        
        downloader.fetchData(at: urlString) { result in
            expectation.fulfill()
            
            XCTAssertTrue(self.session.dataTaskCalled)
            XCTAssertEqual(self.session.dataTaskUrlArg, url)
            
            switch result {
            case .success:
                XCTFail("Expected to fail")
            case .failure(let error):
                XCTAssertEqual(error, .noDataReturned)
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
