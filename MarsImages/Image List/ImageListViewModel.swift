//
//  ImageListViewModel.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/16/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import Foundation

protocol ImageListViewModel: class {
    var title: String { get }
    var photos: [Photo] { get }
    var hasFetchedAllPhotos: Bool { get }
    var delegate: ImageListViewModelDelegate?  { get set }
    
    func fetchInitialPhotos()
    func fetchMorePhotos()
    func downloadImage(for photo: Photo)
}

protocol ImageListViewModelDelegate: class {
    func photosListDidChange()
    func failedToFetchPhotos(with error: Error)
    func didLoadImage(atIndex index: Int)
    func didFailToLoadImage(atIndex index: Int, with error: Error)
}

final class ImageListViewModelImpl: ImageListViewModel {
    
    private let api: RoverPhotosApi
    private let urlDataDownloader: UrlDataDownloader
    private var nextPage: UInt = 1
    private let imageDownloadQueue: OperationQueue
    
    private var isFetchingPhotos = false
    
    let title: String = "Image List"
    var hasFetchedAllPhotos = false
    
    private let photosSerialQueue = DispatchQueue(label: "ImageListViewModel:photos:serial", qos: .userInteractive)
    var photos: [Photo] = [] {
        didSet {
            delegate?.photosListDidChange()
        }
    }
    
    weak var delegate: ImageListViewModelDelegate?
    
    init(api: RoverPhotosApi = RoverPhotosApiImpl(),
         urlDataDownloader: UrlDataDownloader = UrlDataDownloaderImpl(),
         imageDownloadQueue: OperationQueue = OperationQueue()) {
        
        self.api = api
        self.urlDataDownloader = urlDataDownloader
        self.imageDownloadQueue = imageDownloadQueue
        
        imageDownloadQueue.qualityOfService = .utility
        imageDownloadQueue.maxConcurrentOperationCount = 10
    }
    
    func fetchInitialPhotos() {
        isFetchingPhotos = true
        
        print("MyDebug: Fetching page: \(nextPage)")
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
                self?.delegate?.failedToFetchPhotos(with: error)
            }
        }
    }
    
    func fetchMorePhotos() {
        guard !isFetchingPhotos else {
            return
        }
        
        print("MyDebug: Fetching next page: \(nextPage)")
        isFetchingPhotos = true
        api.fetchPhotos(page: nextPage) { [weak self] result in
            defer {
                self?.isFetchingPhotos = false
            }
            
            switch result {
            case .success(let photos):
                self?.photosSerialQueue.sync { [weak self] in
                    self?.photos += photos
                }
                
                if photos.count == 0 {
                    self?.hasFetchedAllPhotos = true
                } else {
                    self?.nextPage += 1
                }
                
            case .failure(let error):
                self?.delegate?.failedToFetchPhotos(with: error)
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
            guard let self = self, let result = downloadOp.result else {
                return
            }
            
            self.photosSerialQueue.sync {
                guard let index = self.photos.firstIndex(where: { $0.id == photo.id }) else {
                    return
                }
                
                switch result {
                case .success:
                    self.delegate?.didLoadImage(atIndex: index)
                case .failure(let error):
                    self.delegate?.didFailToLoadImage(atIndex: index, with: error)
                }
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
