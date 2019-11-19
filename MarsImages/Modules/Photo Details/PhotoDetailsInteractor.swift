//
//  PhotoDetailsInteractor.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import UIKit

struct PhotoDetails: Equatable {
    let imageData: Data?
    let formattedDate: String
    let cameraName: String
    let roverName: String
    let roverStatus: String
}

final class PhotoDetailsInteractor: PhotoDetailsInput {
    
    weak var output: PhotoDetailsOutput?
    
    private let photo: Photo
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    // MARK: - PhotoDetailsInput
    
    func didRequestPhotoDetails() {
        let details = PhotoDetails(imageData: photo.imageData,
                                   formattedDate: dateFormatter.string(from: photo.date),
                                   cameraName: photo.camera.fullName,
                                   roverName: photo.rover.name,
                                   roverStatus: photo.rover.status.localizedUppercase)
        
        output?.didRetrievePhotoDetails(details)
    }
}
