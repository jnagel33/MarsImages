//
//  PhotoListContracts.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import Foundation

protocol PhotoListWireframe: class {
    func showDetails(for photo: Photo)
    func showFailedToFetchPhotosAlert(with description: String)
}

protocol PhotoListPresenting: class {
    func didBecomeReady()
    func didSelect(photo: Photo)
    func didRequestMorePhotos()
    func didRequestImage(for photo: Photo)
}

protocol PhotoListOutput: class {
    func didUpdateList(photos: [Photo])
    func didFailToFetchPhotos(with error: Error)
    func didFinishImageDownload(for photo: Photo, at index: Int)
    func didReachEndOfPhotos()
}

protocol PhotoListInput: class {
    func fetchInitialPhotos()
    func fetchMorePhotos()
    func downloadImage(for photo: Photo)
}

protocol PhotoListView: class {
    func updatePhotos(_ photos: [Photo])
    func updatePhoto(_ photo: Photo, at index: Int)
    func didReachEndOfPhotos()
}
