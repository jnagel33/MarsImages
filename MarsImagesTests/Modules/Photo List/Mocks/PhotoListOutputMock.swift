//
//  PhotoListOutputMock.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages

class PhotoListOutputMock: PhotoListOutput {
    
    var didUpdateListCalled = false
    var didUpdateListPhotosArg: [Photo]?
    func didUpdateList(photos: [Photo]) {
        didUpdateListCalled = true
        didUpdateListPhotosArg = photos
    }
    
    var didFailToFetchPhotosCalled = false
    var didFailToFetchPhotosErrorArg: Error?
    func didFailToFetchPhotos(with error: Error) {
        didFailToFetchPhotosCalled = true
        didFailToFetchPhotosErrorArg = error
    }
    
    var didFinishImageDownloadCalled = false
    var didFinishImageDownloadPhotoArg: Photo?
    var didFinishImageDownloadIndexArg: Int?
    func didFinishImageDownload(for photo: Photo, at index: Int) {
        didFinishImageDownloadCalled = true
        didFinishImageDownloadPhotoArg = photo
        didFinishImageDownloadIndexArg = index
    }
    
    var didReachEndOfPhotosCalled = false
    func didReachEndOfPhotos() {
        didReachEndOfPhotosCalled = true
    }
}
