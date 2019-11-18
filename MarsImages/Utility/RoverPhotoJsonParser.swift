//
//  RoverPhotoJsonParser.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/16/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import Foundation

enum RoverPhotoJsonParserError: Error {
    case unexpectedJSONFormat
    case failedToParsePhotoInfo
    case failedToParseCameraInfo
    case failedToParseRoverInfo
}

protocol RoverPhotoJsonParser {
    func photos(from json: Any) throws -> [Photo]
}

final class RoverPhotoJsonParserImpl: RoverPhotoJsonParser {
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    func photos(from json: Any) throws -> [Photo] {
        guard let baseInfo = json as? [String: [[String: Any]]],
            let photosInfo = baseInfo["photos"] else {
            throw RoverPhotoJsonParserError.unexpectedJSONFormat
        }
        
        var photos: [Photo] = []
            
        for photoInfo in photosInfo {
            guard let id = photoInfo["id"] as? Int,
                 let url = photoInfo["img_src"] as? String,
             let dateStr = photoInfo["earth_date"] as? String,
                let date = dateFormatter.date(from: dateStr),
          let cameraInfo = photoInfo["camera"] as? [String: Any],
           let roverInfo = photoInfo["rover"] as? [String: Any] else {
                throw RoverPhotoJsonParserError.failedToParsePhotoInfo
            }
            
            guard let cameraId = cameraInfo["id"] as? Int,
                 let shortName = cameraInfo["name"] as? String,
                  let fullName = cameraInfo["full_name"] as? String,
             let cameraRoverId = cameraInfo["rover_id"] as? Int else {
                throw RoverPhotoJsonParserError.failedToParseCameraInfo
            }
            
            let camera = Camera(id: cameraId, shortName: shortName, fullName: fullName, roverId: cameraRoverId)
            
            guard let roverId = roverInfo["id"] as? Int,
                let roverName = roverInfo["name"] as? String,
              let roverStatus = roverInfo["status"] as? String,
       let roverLaunchDateStr = roverInfo["launch_date"] as? String,
          let roverLaunchDate = dateFormatter.date(from: roverLaunchDateStr),
      let roverLandingDateStr = roverInfo["landing_date"] as? String,
         let roverLandingDate = dateFormatter.date(from: roverLandingDateStr) else {
                throw RoverPhotoJsonParserError.failedToParseRoverInfo
            }
            
            let rover = Rover(id: roverId, name: roverName, status: roverStatus, landingDate: roverLandingDate, launchDate: roverLaunchDate)
            let photo = Photo(id: id, url: url, date: date, camera: camera, rover: rover)
            
            photos.append(photo)
        }
        
        return photos
    }
}
