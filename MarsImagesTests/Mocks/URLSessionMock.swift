//
//  URLSessionMock.swift
//  MarsImagesTests
//
//  Created by Josh Nagel on 11/18/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import Foundation

class URLSessionMock: URLSession {
    
    override init() {}
    
    var dataTaskCalled = false
    var dataTaskUrlArg: URL?
    var dataTaskResult: (Data?, URLResponse?, Error?)?
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCalled = true
        dataTaskUrlArg = url
        if let result = dataTaskResult {
            completionHandler(result.0, result.1, result.2)
        }
        
        return URLSessionDataTaskMock()
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    override init() {}
}
