//
//  UrlDataDownloader.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import Foundation

enum UrlDataDownloaderError: Error, Equatable {
    case invalidUrl
    case fetchError(causedBy: Error)
    case noDataReturned
    case serverError
    
    var isFetchError: Bool {
        if case .fetchError = self {
            return true
        }
        return false
    }
    
    static func == (lhs: UrlDataDownloaderError, rhs: UrlDataDownloaderError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidUrl, .invalidUrl): return true
        case (.noDataReturned, .noDataReturned): return true
        case (.serverError, .serverError): return true
        default: return false
        }
    }
}

protocol UrlDataDownloader {
    func fetchData(at url: String, completion: @escaping (Result<Data, UrlDataDownloaderError>) -> Void)
}

final class UrlDataDownloaderImpl: UrlDataDownloader {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchData(at url: String, completion: @escaping (Result<Data, UrlDataDownloaderError>) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        urlSession.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                completion(.failure(.fetchError(causedBy: error)))
            } else {
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    completion(.failure(.serverError))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noDataReturned))
                    return
                }
                
                completion(.success(data))
            }
        }
        .resume()
    }
}

