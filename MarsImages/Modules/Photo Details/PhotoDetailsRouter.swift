//
//  PhotoDetailsRouter.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import UIKit

final class PhotoDetailsRouter: PhotoDetailsWireframe {
    
    private weak var viewController: UIViewController?
    
    init(withViewController viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func resolveModule(with photo: Photo) -> UIViewController {
        let viewController = PhotoDetailsViewController()
        let router = PhotoDetailsRouter(withViewController: viewController)
        let interactor = PhotoDetailsInteractor(photo: photo)
        let presenter = PhotoDetailsPresenter(router: router, interactor: interactor, view: viewController)
        interactor.output = presenter
        viewController.presenter = presenter
        return viewController
    }
    
    // MARK: - PhotoDetailsWireframe
    
    func dismiss() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.dismiss(animated: true, completion: nil)
        }
    }
}
