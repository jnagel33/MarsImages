//
//  PhotoDetailsPresenterTests.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages
import XCTest

class PhotoDetailsPresenterTests: XCTestCase {
    
    var presenter: PhotoDetailsPresenter!
    
    var router: PhotoDetailsWireframeMock!
    var interactor: PhotoDetailsInputMock!
    var view: PhotoDetailsViewMock!
    
    override func setUp() {
        super.setUp()
        
        router = PhotoDetailsWireframeMock()
        interactor = PhotoDetailsInputMock()
        view = PhotoDetailsViewMock()
        
        presenter = PhotoDetailsPresenter(router: router, interactor: interactor, view: view)
    }
    
    // MARK: - PhotoDetailsPresenting
    
    func test_didBecomeActive_requestsDetails() {
        presenter.didBecomeActive()
        
        XCTAssertTrue(interactor.didRequestPhotoDetailsCalled)
    }
    
    func didTapCloseButton() {
        presenter.didTapCloseButton()
        
        XCTAssertTrue(router.dismissCalled)
    }
    
    // MARK: - PhotoDetailsOutput
    
    func didRetrievePhotoDetails(_ details: PhotoDetails) {
        let details = PhotoDetails(imageData: nil, formattedDate: "test", cameraName: "camera", roverName: "rover", roverStatus: "active")
        presenter.didRetrievePhotoDetails(details)
        
        XCTAssertTrue(view.setPhotoDetailsCalled)
        XCTAssertEqual(view.setPhotoDetailsDetailsArg, details)
    }
}
