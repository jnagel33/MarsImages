//
//  PhotoListView.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import UIKit

final class PhotoListCustomView: UIView {
    
    struct Constants {
        static let cellSize = CGSize(width: 125, height: 125)
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = PhotoListCustomView.Constants.cellSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoListCollectionViewCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(collectionView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let viewsDictionary = ["child": collectionView]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[child]|", metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[child]|", metrics: nil, views: viewsDictionary))
    }
}
