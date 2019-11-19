//
//  PhotoListPresenterTests.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages
import XCTest

class PhotoListPresenterTests: XCTestCase {
    
    var presenter: PhotoListPresenter!
    
    var router: PhotoListWireframeMock!
    var interactor: PhotoListInputMock!
    var view: PhotoListViewMock!
    
    let photo: Photo = {
        let camera = Camera(id: 1, shortName: "short", fullName: "full", roverId: 1)
        let rover = Rover(id: 1, name: "name", status: "active", landingDate: .distantPast, launchDate: Date())
        return Photo(id: 1, url: "url", date: .distantPast, camera: camera, rover: rover)
    }()

    override func setUp() {
        super.setUp()
        
        router = PhotoListWireframeMock()
        interactor = PhotoListInputMock()
        view = PhotoListViewMock()
        
        presenter = PhotoListPresenter(router: router, interactor: interactor, view: view)
    }
    
    // MARK: - PhotoListPresenting
    
    func test_didBecomeReady_fetchInitialPhotos() {
        presenter.didBecomeReady()
        
        XCTAssertTrue(interactor.fetchInitialPhotosCalled)
    }
    
    func test_didSelectPhoto_showDetails() {
        presenter.didSelect(photo: photo)
        
        XCTAssertTrue(router.showDetailsCalled)
        XCTAssertEqual(router.showDetailsPhotoArg, photo)
    }
    
    func test_didRequestImage_downloadImage() {
        presenter.didRequestImage(for: photo)
        
        XCTAssertTrue(interactor.downloadImageCalled)
        XCTAssertEqual(interactor.downlaodImagePhotoArg, photo)
    }
    
    func test_didRequestMorePhotos_fetchMore() {
        presenter.didRequestMorePhotos()
        
        XCTAssertTrue(interactor.fetchMorePhotosCalled)
    }
    
    // MARK: - PhotoListOutput
    
    func test_didUpdateList_updatesPhotos() {
        let photos = [photo]
        presenter.didUpdateList(photos: photos)
        
        XCTAssertTrue(view.updatePhotosCalled)
        XCTAssertEqual(view.updatePhotosPhotosArg, photos)
    }
    
    func test_didFailToFetchPhotos_showAlert() {
        presenter.didFailToFetchPhotos(with: RoverPhotosAPIError.fetchError(causedBy: .serverError))
        
        XCTAssertTrue(router.showFailedToFetchPhotosAlertCalled)
    }
    
    func test_didFinishImageDownload_updatePhoto() {
        let index = 5
        presenter.didFinishImageDownload(for: photo, at: index)
        
        XCTAssertTrue(view.updatePhotoCalled)
        XCTAssertEqual(view.updatePhotoPhotoArg, photo)
        XCTAssertEqual(view.updatePhotoIndexArg, index)
    }
    
    func test_didReachEndOfPhotos() {
        presenter.didReachEndOfPhotos()
        
        XCTAssertTrue(view.didReachEndOfPhotosCalled)
    }
}
