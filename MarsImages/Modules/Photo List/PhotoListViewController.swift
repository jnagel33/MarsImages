//
//  PhotoListViewController.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import UIKit

final class PhotoListViewController: UIViewController, PhotoListView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let _view = PhotoListCustomView()
    private var photos: [Photo] = []
    private var hasFetchedAllPhotos = false
    
    var presenter: PhotoListPresenting!
    
    override func loadView() {
        self.view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _view.collectionView.dataSource = self
        _view.collectionView.delegate = self
        
        title = "Photo List"
        presenter.didBecomeReady()
    }

    // MARK: - PhotoListView
    
    func updatePhotos(_ photos: [Photo]) {
        DispatchQueue.main.async { [weak self] in
            self?.photos = photos
            self?._view.collectionView.reloadData()
        }
    }
    
    func updatePhoto(_ photo: Photo, at index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.photos[index] = photo
            self?._view.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    func didReachEndOfPhotos() {
        DispatchQueue.main.async { [weak self] in
            self?.hasFetchedAllPhotos = true
        }
    }

    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let photo = photos[indexPath.row]
        cell.populate(image: photo.thumbnailData.flatMap { UIImage(data: $0) })
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        if photo.thumbnailData == nil {
            presenter.didRequestImage(for: photo)
        }
        
        let isLastIndex = indexPath.row == (photos.count - 1)
        if isLastIndex && !hasFetchedAllPhotos {
            presenter.didRequestMorePhotos()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        presenter.didSelect(photo: photo)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset: CGFloat = 300
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        // Attempt to fetch more when we get close to the bottom
        if !hasFetchedAllPhotos && (bottomEdge + offset >= scrollView.contentSize.height) {
            presenter.didRequestMorePhotos()
        }
    }
}
