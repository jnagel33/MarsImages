//
//  PhotoListPresenter.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import Foundation

class PhotoListPresenter: PhotoListPresenting, PhotoListOutput {
    
    private let router: PhotoListWireframe
    private let interactor: PhotoListInput
    private weak var view: PhotoListView?
    
    init(router: PhotoListWireframe,
         interactor: PhotoListInput,
         view: PhotoListView) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    // MARK - PhotoListPresenting
    
    func didBecomeReady() {
        interactor.fetchInitialPhotos()
    }
    
    func didSelect(photo: Photo) {
        router.showDetails(for: photo)
    }
    
    func didRequestMorePhotos() {
        interactor.fetchMorePhotos()
    }
    
    func didRequestImage(for photo: Photo) {
        interactor.downloadImage(for: photo)
    }
    
    // MARK: - PhotoListOutput
    
    func didUpdateList(photos: [Photo]) {
        view?.updatePhotos(photos)
    }
    
    func didFailToFetchPhotos(with error: Error) {
        router.showFailedToFetchPhotosAlert(with: error.localizedDescription)
    }
    
    func didFinishImageDownload(for photo: Photo, at index: Int) {
        view?.updatePhoto(photo, at: index)
    }
    
    func didReachEndOfPhotos() {
        view?.didReachEndOfPhotos()
    }
}
