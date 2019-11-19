//
//  PhotoListViewMock.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages

class PhotoListViewMock: PhotoListView {
    
    var updatePhotosCalled = false
    var updatePhotosPhotosArg: [Photo]?
    func updatePhotos(_ photos: [Photo]) {
        updatePhotosCalled = true
        updatePhotosPhotosArg = photos
    }
    
    var updatePhotoCalled = false
    var updatePhotoPhotoArg: Photo?
    var updatePhotoIndexArg: Int?
    func updatePhoto(_ photo: Photo, at index: Int) {
        updatePhotoCalled = true
        updatePhotoPhotoArg = photo
        updatePhotoIndexArg = index
    }
    
    var didReachEndOfPhotosCalled = false
    func didReachEndOfPhotos() {
        didReachEndOfPhotosCalled = true
    }
}
