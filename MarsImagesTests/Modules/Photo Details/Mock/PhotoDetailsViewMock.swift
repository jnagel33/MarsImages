//
//  PhotoDetailsViewMock.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages

class PhotoDetailsViewMock: PhotoDetailsView {
    
    var setPhotoDetailsCalled = false
    var setPhotoDetailsDetailsArg: PhotoDetails?
    func setPhotoDetails(_ details: PhotoDetails) {
        setPhotoDetailsCalled = true
        setPhotoDetailsDetailsArg = details
    }
}
