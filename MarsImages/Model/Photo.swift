//
//  Photo.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/16/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import Foundation

class Photo: Equatable {
    
    let id: Int
    let url: String
    let date: Date
    let camera: Camera
    let rover: Rover
    
    // Cached image data
    var imageData: Data?
    var thumbnailData: Data?
    
    init(id: Int, url: String, date: Date, camera: Camera, rover: Rover) {
        self.id = id
        self.url = url
        self.date = date
        self.camera = camera
        self.rover = rover
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id &&
            lhs.url == rhs.url &&
            lhs.date == rhs.date &&
            lhs.camera == rhs.camera &&
            lhs.rover == rhs.rover &&
            lhs.imageData == rhs.imageData &&
            lhs.thumbnailData == rhs.thumbnailData
    }
}

struct Camera: Equatable {
    let id: Int
    let shortName: String
    let fullName: String
    let roverId: Int
}

struct Rover: Equatable {
    let id: Int
    let name: String
    let status: String
    let landingDate: Date
    let launchDate: Date
}
