//
//  ImageDownloaderMock.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages
import Foundation

class UrlDataDownloaderMock: UrlDataDownloader {
    
    var fetchDataCalled = false
    var fetchDataUrlArg: String?
    var fetchDataResult: Result<Data, UrlDataDownloaderError>?
    func fetchData(at url: String, completion: @escaping (Result<Data, UrlDataDownloaderError>) -> Void) {
        fetchDataCalled = true
        fetchDataUrlArg = url
        if let result = fetchDataResult {
            completion(result)
        }
    }
}
