//
//  PhotoListWireframeMock.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages

class PhotoListWireframeMock: PhotoListWireframe {
    
    var showDetailsCalled = false
    var showDetailsPhotoArg: Photo?
    func showDetails(for photo: Photo) {
        showDetailsCalled = true
        showDetailsPhotoArg = photo
    }
    
    var showFailedToFetchPhotosAlertCalled = false
    var showFailedToFetchPhotosAlertDescriptionArg: String?
    func showFailedToFetchPhotosAlert(with description: String) {
        showFailedToFetchPhotosAlertCalled = true
        showFailedToFetchPhotosAlertDescriptionArg = description
    }
}
