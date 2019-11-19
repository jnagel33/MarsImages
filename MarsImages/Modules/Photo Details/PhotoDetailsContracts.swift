//
//  PhotoDetailsContracts.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import Foundation

protocol PhotoDetailsWireframe: class {
    func dismiss()
}

protocol PhotoDetailsPresenting: class {
    func didBecomeActive()
    func didTapCloseButton()
}

protocol PhotoDetailsInput: class {
    func didRequestPhotoDetails()
}

protocol PhotoDetailsOutput: class {
    func didRetrievePhotoDetails(_ details: PhotoDetails)
}

protocol PhotoDetailsView: class {
    func setPhotoDetails(_ details: PhotoDetails)
}
