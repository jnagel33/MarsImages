//
//  ImageListViewController.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/16/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import UIKit

final class ImageListViewController: UIViewController {
    
    private let _view = ImageListView()
    private let viewModel: ImageListViewModel
    
    init(viewModel: ImageListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _view.collectionView.dataSource = self
        _view.collectionView.delegate = self
        
        title = viewModel.title
        viewModel.fetchInitialPhotos()
    }
}

// MARK: - UICollectionViewDataSource

extension ImageListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let photo = viewModel.photos[indexPath.row]
        cell.populate(image: photo.thumbnailData.flatMap { UIImage(data: $0) })
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ImageListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = viewModel.photos[indexPath.row]
        viewModel.downloadImage(for: photo)
        
        let isLastIndex = indexPath.row == (viewModel.photos.count - 1)
        if isLastIndex && !viewModel.hasFetchedAllPhotos {
            viewModel.fetchMorePhotos()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.photos[indexPath.row]
        let vm = ImageDetailViewModelImpl(photo: photo)
        let vc = ImageDetailViewController(viewModel: vm)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset: CGFloat = 300
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        // Attempt to fetch more when we get close to the bottom
        if !viewModel.hasFetchedAllPhotos && (bottomEdge + offset >= scrollView.contentSize.height) {
            viewModel.fetchMorePhotos()
        }
    }
}

// MARK: - ImageListViewModelDelegate

extension ImageListViewController: ImageListViewModelDelegate {
    
    func photosListDidChange() {
        DispatchQueue.main.async { [weak self] in
            self?._view.collectionView.reloadData()
        }
    }
    
    func failedToFetchPhotos(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, self.presentedViewController == nil else {
                return
            }
            
            let alert = UIAlertController(title: "Failed to fetch photos", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didLoadImage(atIndex index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?._view.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    func didFailToLoadImage(atIndex index: Int, with error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?._view.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
}

