//
//  RoverPhotosApiMock.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages

class RoverPhotosApiMock: RoverPhotosApi {
    
    var fetchPhotosCalled = false
    var fetchPhotosCallCount = 0
    var fetchPhotosPageArg: UInt?
    var fetchPhotosResult: Result<[Photo], RoverPhotosAPIError>?
    func fetchPhotos(page: UInt, completion: @escaping (Result<[Photo], RoverPhotosAPIError>) -> Void) {
        fetchPhotosCalled = true
        fetchPhotosCallCount += 1
        fetchPhotosPageArg = page
        if let result = fetchPhotosResult {
            completion(result)
        }
    }
}
