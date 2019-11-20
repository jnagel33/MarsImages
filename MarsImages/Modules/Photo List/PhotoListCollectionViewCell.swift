//
//  PhotoListCollectionViewCell.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/16/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import UIKit

class PhotoListCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.hidesWhenStopped = true
        loader.isHidden = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(imageView)
        addSubview(loader)
        
        let viewsDictionary = ["imageView": imageView, "loader": loader]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[loader]|", metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[loader]|", metrics: nil, views: viewsDictionary))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        loader.isHidden = true
    }
    
    func populate(image: UIImage?) {
        if let image = image {
            imageView.image = image
            loader.stopAnimating()
        } else {
            loader.isHidden = false
            loader.startAnimating()
        }
    }
}
