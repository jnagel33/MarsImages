//
//  Photo.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/16/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import Foundation

class Photo {
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
}

struct Camera {
    let id: Int
    let shortName: String
    let fullName: String
    let roverId: Int
}

struct Rover {
    let id: Int
    let name: String
    let status: String
    let landingDate: Date
    let launchDate: Date
}
