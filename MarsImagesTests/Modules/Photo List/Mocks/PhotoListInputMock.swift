//
//  PhotoListInputMock.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages

class PhotoListInputMock: PhotoListInput {
    
    var fetchInitialPhotosCalled = false
    func fetchInitialPhotos() {
        fetchInitialPhotosCalled = true
    }
    
    var fetchMorePhotosCalled = false
    func fetchMorePhotos() {
        fetchMorePhotosCalled = true
    }
    
    var downloadImageCalled = false
    var downlaodImagePhotoArg: Photo?
    func downloadImage(for photo: Photo) {
        downloadImageCalled = true
        downlaodImagePhotoArg = photo
    }
}
