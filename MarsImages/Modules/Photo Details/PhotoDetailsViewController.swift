//
//  PhotoDetailsViewController.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import UIKit

final class PhotoDetailsViewController: UIViewController, PhotoDetailsView {
    
    var presenter: PhotoDetailsPresenting!
    
    private let _view = PhotoDetailView()
    
    override func loadView() {
        self.view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo Details"
        setupNavigationButton()
        presenter.didBecomeActive()
    }
    
    private func setupNavigationButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
    }
    
    @objc func didTapCloseButton() {
        presenter.didTapCloseButton()
    }
    
    // MARK: - PhotoDetailsView
    
    func setPhotoDetails(_ details: PhotoDetails) {
        _view.populate(details: details)
    }
}
