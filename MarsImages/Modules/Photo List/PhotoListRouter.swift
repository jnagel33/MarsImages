//
//  PhotoListRouter.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import UIKit

final class PhotoListRouter: PhotoListWireframe {
    
    private let viewController: UIViewController
    
    init(withViewController viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func resolveModule() -> UIViewController {
        let viewController = PhotoListViewController()
        let router = PhotoListRouter(withViewController: viewController)
        let interactor = PhotoListInteractor()
        let presenter = PhotoListPresenter(router: router, interactor: interactor, view: viewController)
        interactor.output = presenter
        viewController.presenter = presenter
        return viewController
    }
    
    // MARK: - PhotoListWireframe
    
    func showDetails(for photo: Photo) {
        DispatchQueue.main.async { [viewController] in
            let photoDetailsViewController = PhotoDetailsRouter.resolveModule(with: photo)
            let navigationController = UINavigationController(rootViewController: photoDetailsViewController)
            viewController.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func showFailedToFetchPhotosAlert(with description: String) {
        DispatchQueue.main.async { [viewController] in
            guard viewController.presentedViewController == nil else {
                return
            }
            
            let alert = UIAlertController(title: "Failed to fetch photos", message: description, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
