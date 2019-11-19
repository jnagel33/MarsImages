//
//  PhotoDetailsInputMock.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages

class PhotoDetailsInputMock: PhotoDetailsInput {
    
    var didRequestPhotoDetailsCalled = false
    func didRequestPhotoDetails() {
        didRequestPhotoDetailsCalled = true
    }
}
