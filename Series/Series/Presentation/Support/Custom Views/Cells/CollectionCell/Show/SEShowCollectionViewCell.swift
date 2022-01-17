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
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "ic_placeholder")
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
    private lazy var gradientView: UIView = {
        let view: UIView = UIView(frame: .infinite)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        return gradient
    }()
    private var configurator: SEShowCellConfigurator?
    private var presenter: SEShowCellPresenterInput?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient.frame = self.posterImageView.frame
        self.posterImageView.layer.cornerRadius = 4.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.configurator = nil
        self.presenter = nil
        self.posterImageView.image = UIImage(named: "ic_placeholder")
        self.posterImageView.backgroundColor = .clear
        self.showNameLabel.text = SEKeys.MessageKeys.emptyText
        self.gradientView.isHidden = false
        self.stopAnimation()
    }
    
    // MARK: - Setup
    private func setupViews() {
        self.addSubview(posterImageView)
        self.addSubview(showNameLabel)
        self.posterImageView.addSubview(gradientView)
        NSLayoutConstraint.activate([self.posterImageView.topAnchor.constraint(equalTo: self.topAnchor),
                                     self.posterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     self.posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     self.posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        NSLayoutConstraint.activate([self.showNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0),
                                     self.showNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
                                     self.showNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
                                     self.showNameLabel.heightAnchor.constraint(equalToConstant: self.bounds.height / 4.0)])
        NSLayoutConstraint.activate([self.gradientView.topAnchor.constraint(equalTo: self.posterImageView.topAnchor),
                                     self.gradientView.bottomAnchor.constraint(equalTo: self.posterImageView.bottomAnchor),
                                     self.gradientView.leadingAnchor.constraint(equalTo: self.posterImageView.leadingAnchor),
                                     self.gradientView.trailingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor)])
        self.gradientView.layer.insertSublayer(gradient, at: 0)
        self.posterImageView.bringSubviewToFront(gradientView)
        SEStylesApp.personalizeLabelBold(self.showNameLabel, withSizeFont: 12.0)
    }
    
    func setupCell(from show: SEDisplayModel) {
        self.configurator = SEShowCellConfigurator(from: self, showInfo: show)
        self.presenter = configurator?.configure()
        self.presenter?.getPoster()
    }
    
    func setupShimmerCell() {
        self.posterImageView.image = nil
        self.gradientView.isHidden = true
        self.startAnimating()
    }
}

// MARK: - SEShowCollectionViewCellOutput's implementation
extension SEShowCollectionViewCell: SEShowCollectionViewCellOutput {
    func didRetrievePoster(imageData data: Data?, name: String) {
        self.showNameLabel.text = name
        if let imgData = data {
            self.posterImageView.image = UIImage(data: imgData)
        }
    }
}
