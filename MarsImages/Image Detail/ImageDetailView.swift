//
//  ImageDetailView.swift
//  MarsImages
//
//  Created by Josh Nagel on 11/17/19.
//  Copyright © 2019 jnagel. All rights reserved.
//

import UIKit

final class ImageDetailView: UIView {
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let dateLabelPrefix = "Date Taken: "
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cameraHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Camera:"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cameraNameLabelPrefix = "Name: "
    private lazy var cameraNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var roverHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Rover:"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let roverNameLabelPrefix = "Name: "
    private lazy var roverNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let roverStatusLabelPrefix = "Status: "
    private lazy var roverStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(mainStackView)
        
        [imageView, detailStackView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        [dateLabel, cameraHeaderLabel, cameraNameLabel, roverHeaderLabel, roverNameLabel, roverStatusLabel].forEach {
            detailStackView.addArrangedSubview($0)
        }
        
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(image: UIImage?, formattedDate: String, cameraName: String, roverName: String, roverStatus: String) {
        self.imageView.image = image
        self.dateLabel.text = dateLabelPrefix + formattedDate
        self.cameraNameLabel.text = cameraNameLabelPrefix + cameraName
        self.roverNameLabel.text = roverNameLabelPrefix + roverName
        self.roverStatusLabel.text = roverStatusLabelPrefix + roverStatus
    }
    
    // MARK: - Private
    
    private func setupContraints() {
        let viewsDictionary = ["stackView": mainStackView, "topLayoutGuide": safeAreaLayoutGuide]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackView]-16-|", metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[stackView]-30-|", metrics: nil, views: viewsDictionary))
    }
}
