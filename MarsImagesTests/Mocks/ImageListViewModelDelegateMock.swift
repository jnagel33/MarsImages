//
//  ImageListViewModelDelegateMock.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages

class ImageListViewModelDelegateMock: ImageListViewModelDelegate {
    var photosListDidChangeCalled = false
    func photosListDidChange() {
        photosListDidChangeCalled = true
    }
    
    var failedToFetchPhotosCalled = false
    var failedToFetchPhotosErrorArg: Error?
    func failedToFetchPhotos(with error: Error) {
        failedToFetchPhotosCalled = true
        failedToFetchPhotosErrorArg = error
    }
    
    var didLoadImageCalled = false
    var didLoadImageIndexArg: Int?
    func didLoadImage(atIndex index: Int) {
        didLoadImageCalled = true
        didLoadImageIndexArg = index
    }
    
    var didFailToLoadImageCalled = false
    var didFailedToLoadImageIndexArg: Int?
    var didFailedToLoadImageErrorArg: Error?
    func didFailToLoadImage(atIndex index: Int, with error: Error) {
        didFailToLoadImageCalled = true
        didFailedToLoadImageIndexArg = index
        didFailedToLoadImageErrorArg = error
    }
}
