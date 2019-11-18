//
//  ImageDetailViewModel.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import UIKit

protocol ImageDetailViewModel {
    var title: String { get }
    var image: UIImage? { get }
    var camera: Camera { get }
    var rover: Rover { get }
    var formattedDate: String { get }
}

final class ImageDetailViewModelImpl: ImageDetailViewModel {
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private let photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    var title: String = "Photo Details"
    
    var formattedDate: String {
        return dateFormatter.string(from: photo.date)
    }
    
    var image: UIImage? {
        guard let data = photo.imageData else {
            return nil
        }
        return UIImage(data: data)
    }
    
    var rover: Rover {
        return photo.rover
    }
    
    var camera: Camera {
        return photo.camera
    }
}
