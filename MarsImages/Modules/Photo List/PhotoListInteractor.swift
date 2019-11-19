//
//  PhotoListInteractor.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import Foundation

final class PhotoListInteractor: PhotoListInput {
    
    weak var output: PhotoListOutput?
    
    private let api: RoverPhotosApi
    private let urlDataDownloader: UrlDataDownloader
    private let imageDownloadQueue: OperationQueue
    
    private var nextPage: UInt = 1
    private var isFetchingPhotos = false
    private let photosSerialQueue = DispatchQueue(label: "ImageListViewModel:photos:serial", qos: .userInteractive)

    private var photos: [Photo] = [] {
        didSet {
            output?.didUpdateList(photos: photos)
        }
    }
    
    init(api: RoverPhotosApi = RoverPhotosApiImpl(),
         urlDataDownloader: UrlDataDownloader = UrlDataDownloaderImpl(),
         imageDownloadQueue: OperationQueue = OperationQueue()) {
        self.api = api
        self.urlDataDownloader = urlDataDownloader
        self.imageDownloadQueue = imageDownloadQueue
        
        imageDownloadQueue.qualityOfService = .utility
        imageDownloadQueue.maxConcurrentOperationCount = 10
    }
    
    // MARK: - PhotoListInput
    
    func fetchInitialPhotos() {
        isFetchingPhotos = true
        
        api.fetchPhotos(page: nextPage) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photosSerialQueue.sync { [weak self] in
                    self?.photos = photos
                }
                
                self?.nextPage += 1
                self?.isFetchingPhotos = false
                
                self?.fetchMorePhotos()
                
            case .failure(let error):
                self?.isFetchingPhotos = false
                self?.output?.didFailToFetchPhotos(with: error)
            }
        }
    }
    
    func fetchMorePhotos() {
        guard !isFetchingPhotos else {
            return
        }
        
        isFetchingPhotos = true
        api.fetchPhotos(page: nextPage) { [weak self] result in
            defer {
                self?.isFetchingPhotos = false
            }
            
            switch result {
            case .success(let photos):
                if photos.count == 0 {
                    self?.output?.didReachEndOfPhotos()
                } else {
                    self?.photosSerialQueue.sync { [weak self] in
                        self?.photos += photos
                    }
                    self?.nextPage += 1
                }
                
            case .failure(let error):
                self?.output?.didFailToFetchPhotos(with: error)
            }
        }
    }
    
    func downloadImage(for photo: Photo) {
        guard !downloadOperationExists(for: photo) else {
            // We already have a download operation for this photo
            return
        }
        
        let downloadOp = ImageDownloadOperation(photo: photo, urlDataDownloader: urlDataDownloader)
        
        let completionBlock = { [weak self] in
            guard let self = self, downloadOp.result != nil else {
                // Ignore if no result
                return
            }
            
            self.photosSerialQueue.sync {
                guard let index = self.photos.firstIndex(where: { $0.id == photo.id }) else {
                    return
                }
                self.output?.didFinishImageDownload(for: photo, at: index)
            }
        }
        downloadOp.completionBlock = completionBlock
        
        imageDownloadQueue.addOperation(downloadOp)
    }
    
    // MARK: - Private
    
    private func downloadOperationExists(for photo: Photo) -> Bool {
        guard let downloadOps = imageDownloadQueue.operations as? [ImageDownloadOperation] else {
            return false
        }
        
        return downloadOps.contains { op -> Bool in
            guard op.id == photo.id else {
                return false
            }
            return !op.isFinished && !op.isCancelled
        }
    }
}
