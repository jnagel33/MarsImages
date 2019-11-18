//
//  ImageListViewModelTests.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages
import XCTest

class ImageListViewModelTests: XCTestCase {
    
    var vm: ImageListViewModelImpl!
    
    var api: RoverPhotosApiMock!
    var urlDataDownloader: UrlDataDownloaderMock!
    var imageDownloadQueue: OperationQueueMock!
    var delegate: ImageListViewModelDelegateMock!
    
    private let photo: Photo = {
        let camera = Camera(id: 1, shortName: "short", fullName: "full", roverId: 1)
        let rover = Rover(id: 1, name: "name", status: "active", landingDate: .distantPast, launchDate: Date())
        return Photo(id: 1, url: "url", date: .distantPast, camera: camera, rover: rover)
    }()

    override func setUp() {
        super.setUp()
        
        api = RoverPhotosApiMock()
        urlDataDownloader = UrlDataDownloaderMock()
        imageDownloadQueue = OperationQueueMock()
        delegate = ImageListViewModelDelegateMock()
        
        vm = ImageListViewModelImpl(api: api, urlDataDownloader: urlDataDownloader, imageDownloadQueue: imageDownloadQueue)
        
        vm.delegate = delegate
    }
    
    // MARK: - Fetch initial photos
    
    func test_fetchInitialPhotos_success() {
        let photos = [photo]
        api.fetchPhotosResult = .success(photos)
        
        vm.fetchInitialPhotos()
        
        XCTAssertTrue(api.fetchPhotosCalled)
        
        // It is expected that the second page is fetched on success
        XCTAssertEqual(api.fetchPhotosCallCount, 2)
        XCTAssertEqual(api.fetchPhotosPageArg, 2)
        XCTAssertEqual(vm.photos.count, photos.count * 2)
        
        XCTAssertFalse(vm.hasFetchedAllPhotos)
        XCTAssertTrue(delegate.photosListDidChangeCalled)
    }
    
    func test_fetchInitialPhotos_failure() {
        api.fetchPhotosResult = .failure(.fetchError(causedBy: .serverError))
        
        vm.fetchInitialPhotos()
        
        XCTAssertTrue(api.fetchPhotosCalled)
        XCTAssertEqual(api.fetchPhotosPageArg, 1)
        XCTAssertEqual(vm.photos.count, 0)
        XCTAssertFalse(vm.hasFetchedAllPhotos)
        XCTAssertTrue(delegate.failedToFetchPhotosCalled)
        XCTAssertEqual(delegate.failedToFetchPhotosErrorArg as? RoverPhotosAPIError, .fetchError(causedBy: .serverError))
    }
    
    /// MARK: - Fetch more photos
    
    func test_fetchMorePhotos_success() {
        let photos = [photo]
        api.fetchPhotosResult = .success(photos)
        
        vm.fetchMorePhotos()
        
        XCTAssertTrue(api.fetchPhotosCalled)
        XCTAssertEqual(api.fetchPhotosPageArg, 1)
        XCTAssertEqual(vm.photos.count, photos.count)
        XCTAssertFalse(vm.hasFetchedAllPhotos)
        XCTAssertTrue(delegate.photosListDidChangeCalled)
    }
    
    func test_fetchMorePhotos_emptySuccess() {
        api.fetchPhotosResult = .success([])
        
        vm.fetchMorePhotos()
        
        XCTAssertTrue(api.fetchPhotosCalled)
        XCTAssertEqual(api.fetchPhotosPageArg, 1)
        XCTAssertEqual(vm.photos.count, 0)
        XCTAssertTrue(vm.hasFetchedAllPhotos)
        XCTAssertTrue(delegate.photosListDidChangeCalled)
    }
    
    func test_fetchMorePhotos_failure() {
        api.fetchPhotosResult = .failure(.fetchError(causedBy: .serverError))
        
        vm.fetchInitialPhotos()
        
        XCTAssertTrue(api.fetchPhotosCalled)
        XCTAssertEqual(api.fetchPhotosPageArg, 1)
        XCTAssertEqual(vm.photos.count, 0)
        XCTAssertTrue(delegate.failedToFetchPhotosCalled)
        XCTAssertFalse(vm.hasFetchedAllPhotos)
        XCTAssertEqual(delegate.failedToFetchPhotosErrorArg as? RoverPhotosAPIError, .fetchError(causedBy: .serverError))
    }
    
    // MARK: - Download image
    
    func test_downloadImage_addsOperation() {
        vm.downloadImage(for: photo)
        
        XCTAssertTrue(imageDownloadQueue.addOperationCalled)
    }
    
    func test_downloadImage_opAlreadyExists_ignored() {
        imageDownloadQueue.operationsResult = [ImageDownloadOperation(photo: photo, urlDataDownloader: urlDataDownloader)]
        
        vm.downloadImage(for: photo)
        
        XCTAssertFalse(imageDownloadQueue.addOperationCalled)
    }
}
