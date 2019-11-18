//
//  ImageDetailViewController.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/16/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import UIKit

final class ImageDetailViewController: UIViewController {
    
    private let _view = ImageDetailView()
    private let viewModel: ImageDetailViewModel
    
    init(viewModel: ImageDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBindings()
    }
    
    // MARK: - Private
    
    private func configureBindings() {
        title = viewModel.title
        
        _view.populate(image: viewModel.image,
                       formattedDate: viewModel.formattedDate,
                       cameraName: viewModel.camera.fullName,
                       roverName: viewModel.rover.name,
                       roverStatus: viewModel.rover.status)
    }
}
