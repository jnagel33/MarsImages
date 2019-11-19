//
//  PhotoDetailsPresenter.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import Foundation

final class PhotoDetailsPresenter: PhotoDetailsPresenting, PhotoDetailsOutput {
    
    private let router: PhotoDetailsWireframe
    private let interactor: PhotoDetailsInput
    private weak var view: PhotoDetailsView?
    
    init(router: PhotoDetailsWireframe,
         interactor: PhotoDetailsInput,
         view: PhotoDetailsView) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    // MARK: - PhotoDetailsPresenting
    
    func didBecomeActive() {
        interactor.didRequestPhotoDetails()
    }
    
    func didTapCloseButton() {
        router.dismiss()
    }
    
    // MARK: - PhotoDetailsOutput
    
    func didRetrievePhotoDetails(_ details: PhotoDetails) {
        view?.setPhotoDetails(details)
    }
}
