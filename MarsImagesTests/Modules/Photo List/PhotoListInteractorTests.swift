//
//  PhotoListInteractorTests.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages
import XCTest

class PhotoListInteractorTests: XCTestCase {
    
    var interactor: PhotoListInteractor!
    
    var api: RoverPhotosApiMock!
    var urlDataDownloader: UrlDataDownloaderMock!
    var imageDownloadQueue: OperationQueueMock!
    var output: PhotoListOutputMock!
    
    let photo: Photo = {
        let camera = Camera(id: 1, shortName: "short", fullName: "full", roverId: 1)
        let rover = Rover(id: 1, name: "name", status: "active", landingDate: .distantPast, launchDate: Date())
        return Photo(id: 1, url: "url", date: .distantPast, camera: camera, rover: rover)
    }()

    override func setUp() {
        super.setUp()
        
        api = RoverPhotosApiMock()
        urlDataDownloader = UrlDataDownloaderMock()
        imageDownloadQueue = OperationQueueMock()
        output = PhotoListOutputMock()
        
        interactor = PhotoListInteractor(api: api, urlDataDownloader: urlDataDownloader, imageDownloadQueue: imageDownloadQueue)
        interactor.output = output
    }
    
    // MARK: - Fetch initial photos
    
    func test_fetchInitialPhotos_success() {
        let photos = [photo]
        api.fetchPhotosResult = .success(photos)
        
        interactor.fetchInitialPhotos()
        
        XCTAssertTrue(api.fetchPhotosCalled)
        
        // It is expected that the second page is fetched on success
        XCTAssertEqual(api.fetchPhotosCallCount, 2)
        XCTAssertEqual(api.fetchPhotosPageArg, 2)
        
        XCTAssertFalse(output.didReachEndOfPhotosCalled)
        XCTAssertTrue(output.didUpdateListCalled)
        XCTAssertEqual(output.didUpdateListPhotosArg?.first, photo)
    }
    
    func test_fetchInitialPhotos_failure() {
        api.fetchPhotosResult = .failure(.fetchError(causedBy: .serverError))
        
        interactor.fetchInitialPhotos()
        
        XCTAssertTrue(api.fetchPhotosCalled)
        XCTAssertEqual(api.fetchPhotosPageArg, 1)
        XCTAssertFalse(output.didReachEndOfPhotosCalled)
        XCTAssertTrue(output.didFailToFetchPhotosCalled)
        XCTAssertEqual(output.didFailToFetchPhotosErrorArg as? RoverPhotosAPIError, .fetchError(causedBy: .serverError))
    }
    
    // MARK: - Fetch more photos
    
    func test_fetchMorePhotos_success() {
        let photos = [photo]
        api.fetchPhotosResult = .success(photos)
        
        interactor.fetchMorePhotos()
        
        XCTAssertTrue(api.fetchPhotosCalled)
        XCTAssertEqual(api.fetchPhotosPageArg, 1)
        XCTAssertFalse(output.didReachEndOfPhotosCalled)
        XCTAssertTrue(output.didUpdateListCalled)
        XCTAssertEqual(output.didUpdateListPhotosArg?.first, photo)
        
        interactor.fetchMorePhotos()
            
        // Should increment page number
        XCTAssertEqual(api.fetchPhotosPageArg, 2)
    }
    
    func test_fetchMorePhotos_emptySuccess() {
        api.fetchPhotosResult = .success([])
        
        interactor.fetchMorePhotos()
        
        XCTAssertTrue(api.fetchPhotosCalled)
        XCTAssertEqual(api.fetchPhotosPageArg, 1)
        XCTAssertTrue(output.didReachEndOfPhotosCalled)
        XCTAssertFalse(output.didUpdateListCalled)
    }
    
    func test_fetchMorePhotos_failure() {
        api.fetchPhotosResult = .failure(.fetchError(causedBy: .serverError))
        
        interactor.fetchInitialPhotos()
        
        XCTAssertTrue(api.fetchPhotosCalled)
        XCTAssertEqual(api.fetchPhotosPageArg, 1)
        XCTAssertTrue(output.didFailToFetchPhotosCalled)
        XCTAssertFalse(output.didReachEndOfPhotosCalled)
        XCTAssertEqual(output.didFailToFetchPhotosErrorArg as? RoverPhotosAPIError, .fetchError(causedBy: .serverError))
    }
    
    // MARK: - Download Image
    
    func test_downloadImage_addsOperation() {
        interactor.downloadImage(for: photo)
        
        XCTAssertTrue(imageDownloadQueue.addOperationCalled)
    }
    
    func test_downloadImage_opAlreadyExists_ignored() {
        imageDownloadQueue.operationsResult = [ImageDownloadOperation(photo: photo, urlDataDownloader: urlDataDownloader)]
        
        interactor.downloadImage(for: photo)
        
        XCTAssertFalse(imageDownloadQueue.addOperationCalled)
    }
}
