//
//  SESeasonCollectionViewCell.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import UIKit

protocol SESeasonCollectionViewCellDelegate: AnyObject {
    func didSelectItem(at index: IndexPath)
}

class SESeasonCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    internal lazy var episodesCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5.0, left: 20.0, bottom: 5.0, right: 20.0)
        layout.minimumInteritemSpacing = 0.0
        let itemWidth = UIScreen.main.bounds.width/4.0
        layout.itemSize = CGSize(width: itemWidth, height: self.bounds.height - 10.0)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SEShowCollectionViewCell.self, forCellWithReuseIdentifier: SESeasonCollectionViewCell.collectionCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private static let collectionCellIdentifier: String = "showCell"
    private var displayData: [SEDisplayModel]
    private var cellSection: Int
    private weak var delegate: SESeasonCollectionViewCellDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        self.displayData = []
        self.cellSection = 0
        super.init(frame: frame)
        self.setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Setup
    private func setupViews() {
        self.addSubview(episodesCollectionView)
        NSLayoutConstraint.activate([self.episodesCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
                                     self.episodesCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     self.episodesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     self.episodesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
    
    func setupCell(from data: [SEDisplayModel], section: Int, delegate: SESeasonCollectionViewCellDelegate?) {
        self.displayData = data
        self.cellSection = section
        self.delegate = delegate
        self.episodesCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate's implementation
extension SESeasonCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectItem(at: IndexPath(row: indexPath.row, section: self.cellSection))
    }
}

// MARK: - UICollectionViewDataSource's implementation
extension SESeasonCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.displayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SESeasonCollectionViewCell.collectionCellIdentifier, for: indexPath) as? SEShowCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(from: self.displayData[indexPath.row])
        return cell
    }
}
