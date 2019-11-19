//
//  PhotoDetailsInteractorTests.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

@testable import MarsImages
import XCTest

class PhotoDetailsInteractorTests: XCTestCase {
    
    var interactor: PhotoDetailsInteractor!
    var output: PhotoDetailsOutputMock!
    
    let photo: Photo = {
        let camera = Camera(id: 1, shortName: "short", fullName: "full", roverId: 1)
        let rover = Rover(id: 1, name: "name", status: "active", landingDate: .distantPast, launchDate: Date())
        return Photo(id: 1, url: "url", date: .distantPast, camera: camera, rover: rover)
    }()
    
    override func setUp() {
        super.setUp()
        
        output = PhotoDetailsOutputMock()
        interactor = PhotoDetailsInteractor(photo: photo)
        
        interactor.output = output
    }
    
    func test_didRequestPhotoDetails_didRetrieve() {
        interactor.didRequestPhotoDetails()
        
        XCTAssertTrue(output.didRetrievePhotoDetailsCalled)
        
        let expectedDetails = PhotoDetails(imageData: nil, formattedDate: "Dec 31, 1", cameraName: photo.camera.fullName, roverName: photo.rover.name, roverStatus: photo.rover.status.localizedUppercase)
        XCTAssertEqual(output.didRetrievePhotoDetailsDetailsArg, expectedDetails)
    }
}
