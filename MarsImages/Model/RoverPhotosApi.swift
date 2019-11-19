//
//  RoverPhotosApi.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/16/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import Foundation

enum RoverPhotosAPIError: Error, Equatable {
    case fetchError(causedBy: UrlDataDownloaderError)
    case jsonParseError(causedBy: Error)

    static func == (lhs: RoverPhotosAPIError, rhs: RoverPhotosAPIError) -> Bool {
        switch (lhs, rhs) {
        case (.fetchError(let a), .fetchError(let b)): return a == b
        case (.jsonParseError(let a), .jsonParseError(let b)):
            guard let a1 = a as? RoverPhotoJsonParserError, let b1 = b as? RoverPhotoJsonParserError else {
                return false
            }
            return a1 == b1
        default: return false
        }
    }
}

protocol RoverPhotosApi {
    func fetchPhotos(page: UInt, completion: @escaping (Result<[Photo], RoverPhotosAPIError>) -> Void)
}

final class RoverPhotosApiImpl: RoverPhotosApi {
    
    private let apiKey = "3Bs5xtbl8SBw3eHas050hiubtGlq4EOUZXuoOWCp"
    private let baseURL = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos"
    
    private let apiKeyQueryKey = "api_key"
    private let pageQueryKey = "page"
    private let solQueryKey = "sol"
    
    private let urlDataDownloader: UrlDataDownloader
    private let parser: RoverPhotoJsonParser
    
    init(urlDataDownloader: UrlDataDownloader = UrlDataDownloaderImpl(), parser: RoverPhotoJsonParser = RoverPhotoJsonParserImpl()) {
        self.urlDataDownloader = urlDataDownloader
        self.parser = parser
    }
    
    func fetchPhotos(page: UInt, completion: @escaping (Result<[Photo], RoverPhotosAPIError>) -> Void) {
        let url = buildUrl(page: page)
        
        urlDataDownloader.fetchData(at: url) { [parser] result in
            switch result {
            case .success(let data):
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let photos = try parser.photos(from: json)
                    completion(.success(photos))
                } catch {
                    completion(.failure(.jsonParseError(causedBy: error)))
                }
                
            case .failure(let error):
                completion(.failure(.fetchError(causedBy: error)))
            }
        }
    }
    
    // MARK: - Private
    
    private func buildUrl(page: UInt) -> String {
        var urlString = baseURL
        urlString += "?" + apiKeyQueryKey + "=" + apiKey
        urlString += "&" + pageQueryKey + "=" + "\(page)"
        urlString += "&" + solQueryKey + "=" + "\(100)"
        return urlString
    }
}
