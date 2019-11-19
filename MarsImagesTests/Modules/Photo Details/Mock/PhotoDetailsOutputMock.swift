//
//  PhotoDetailsOutputMock.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages

class PhotoDetailsOutputMock: PhotoDetailsOutput {
    
    var didRetrievePhotoDetailsCalled = false
    var didRetrievePhotoDetailsDetailsArg: PhotoDetails?
    func didRetrievePhotoDetails(_ details: PhotoDetails) {
        didRetrievePhotoDetailsCalled = true
        didRetrievePhotoDetailsDetailsArg = details
    }
}
