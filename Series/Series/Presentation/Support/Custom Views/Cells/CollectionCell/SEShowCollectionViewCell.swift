//
//  SEShowCollectionViewCell.swift
//  Series
//
//  Created by Jesus Cueto on 1/13/22.
//

import UIKit

/**
 Protocol that manages the received data
 */
protocol SEShowCollectionViewCellOutput: AnyObject {
    /**
     Method that is triggered everytime that a poster has finished to load.
     - Parameter data: Image data - `nil` if there was an error with the request.
     - Parameter name: Show's name.
     */
    func didRetrievePoster(imageData data: Data?, name: String)
}

class SEShowCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var showNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = .clear
        label.textColor = SEStylesApp.Color.SE_TextColor
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.7
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var configurator: SEShowCellConfigurator?
    private var presenter: SEShowCellPresenterInput?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.configurator = nil
        self.presenter = nil
        self.posterImageView.image = nil
        self.showNameLabel.text = SEKeys.MessageKeys.emptyText
    }
    
    // MARK: - Setup
    private func setupViews() {
        self.addSubview(posterImageView)
        self.addSubview(showNameLabel)
        NSLayoutConstraint.activate([self.posterImageView.topAnchor.constraint(equalTo: self.topAnchor),
                                     self.posterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     self.posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     self.posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        NSLayoutConstraint.activate([self.showNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0),
                                     self.showNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
                                     self.showNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
                                     self.showNameLabel.heightAnchor.constraint(equalToConstant: self.bounds.height / 4.0)])
        SEStylesApp.personalizeLabelMedium(self.showNameLabel, withSizeFont: 12.0)
    }
    
    func setupCell(from show: SEShowModel) {
        self.configurator = SEShowCellConfigurator(from: self, showInfo: show)
        self.presenter = configurator?.configure()
        self.presenter?.getPoster()
    }
}

// MARK: - SEShowCollectionViewCellOutput's implementation
extension SEShowCollectionViewCell: SEShowCollectionViewCellOutput {
    func didRetrievePoster(imageData data: Data?, name: String) {
        self.showNameLabel.text = name
        if let imgData = data {
            self.posterImageView.image = UIImage(data: imgData)
        } else {
            self.posterImageView.image = UIImage()
        }
    }
}
