//
//  ImageDownloadOperation.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/16/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import UIKit

final class ImageDownloadOperation: Operation {

    private let photo: Photo
    private let urlDataDownloader: UrlDataDownloader
    
    private let thumbnailSize = CGSize(width: 125, height: 125)
    
    var id: Int {
        return photo.id
    }
    var result: Result<Data, UrlDataDownloaderError>?
    
    init(photo: Photo, urlDataDownloader: UrlDataDownloader) {
        self.photo = photo
        self.urlDataDownloader = urlDataDownloader
    }
    
    override func main() {
        guard photo.imageData == nil else {
            completionBlock?()
            return
        }
        
        urlDataDownloader.fetchData(at: photo.url) { [completionBlock, weak self] result in
            guard let self = self else { return }
            if case .success(let data) = result {
                // Cache the image data on success
                self.updatePhoto(self.photo, withData: data)
            }
            self.result = result
            completionBlock?()
        }
    }
    
    // MARK: - Private
    
    private func updatePhoto(_ photo: Photo, withData data: Data) {
        let thumbnailImage = UIImage(data: data)?.resizedImage(to: thumbnailSize)
        photo.thumbnailData = thumbnailImage?.pngData()
        photo.imageData = data
    }
}
