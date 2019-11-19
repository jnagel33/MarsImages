//
//  RoverPhotoJsonParserMock.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages

class RoverPhotoJsonParserMock: RoverPhotoJsonParser {
    
    var photosCalled = false
    var photosJsonArg: Any?
    var photosResult: [Photo]?
    var photosError: RoverPhotoJsonParserError?
    func photos(from json: Any) throws -> [Photo] {
        photosCalled = true
        photosJsonArg = json
        if let photosError = photosError {
            throw photosError
        }
        return photosResult ?? []
    }
}
