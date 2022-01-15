//
//  SEShowDetailViewController.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import UIKit

protocol SEShowDetailView: AnyObject {
    func didRetrieveData(name: String, date: String, genres: String, summary: String, posterData: Data)
}

class SEShowDetailViewController: UIViewController {

    // MARK: - View's Properties
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .top
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = SEStylesApp.Color.SE_TextColor
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.didTapBackButtonAction(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var vInfoStack: UIStackView = {
        let stackView = UIStackView(frame: .infinite)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var seasonsCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 20.0, right: 0.0)
        layout.minimumInteritemSpacing = 0.0
        let itemWidth = UIScreen.main.bounds.width
        layout.headerReferenceSize = CGSize(width: itemWidth, height: 30.0)
        layout.itemSize = CGSize(width: itemWidth, height: UIScreen.main.bounds.height / 7.0)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SESeasonCollectionViewCell.self, forCellWithReuseIdentifier: SEShowDetailViewController.collectionCellIdentifier)
        collectionView.register(SESeasonsHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SEShowDetailViewController.collectionSupplementaryHeaderIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
        
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    private static let collectionCellIdentifier: String = "seasonCell"
    private static let collectionSupplementaryHeaderIdentifier: String = "seasonHeader"
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    internal lazy var configurator: SEShowDetailConfigurator = { return SEShowDetailConfigurator(from: self) }()
    private lazy var presenter: SEShowDetailPresenterInput = { return self.configurator.configure() }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initView()
        self.presenter.loadData()
    }
    
    // MARK: - InitView
    private func initView() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = SEStylesApp.Color.SE_SecondaryColor
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.posterImageView)
        self.contentView.addSubview(self.backButton)
        self.contentView.addSubview(self.vInfoStack)
        self.contentView.addSubview(seasonsCollectionView)
        // ScrollView
        NSLayoutConstraint.activate([self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                                     self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                                     self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)])
        //ContentView
        NSLayoutConstraint.activate([self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
                                     self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
                                     self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
                                     self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
                                     self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)])
        //ImageView
        NSLayoutConstraint.activate([self.posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                                     self.posterImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                                     self.posterImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                                     self.posterImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3.0)])
        // Button
        NSLayoutConstraint.activate([self.backButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
                                     self.backButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0),
                                     self.backButton.heightAnchor.constraint(equalToConstant: 30.0),
                                     self.backButton.widthAnchor.constraint(equalTo: self.backButton.heightAnchor)])
        // UIStackView
        NSLayoutConstraint.activate([self.vInfoStack.topAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: 16.0),
                                     self.vInfoStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                                     self.vInfoStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                                     self.vInfoStack.bottomAnchor.constraint(equalTo: self.seasonsCollectionView.topAnchor, constant: -16.0)])
        // ColectionView
        self.collectionViewHeightConstraint = self.seasonsCollectionView.heightAnchor.constraint(equalToConstant: 100.0)
        NSLayoutConstraint.activate([self.seasonsCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                                     self.seasonsCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                                     self.seasonsCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16.0),
                                     self.collectionViewHeightConstraint!])
    }
    
    private func addShowInfo(title: String, detail: String) {
        let detailView: SEInfoView = SEInfoView(from: title, description: detail)
        self.vInfoStack.addArrangedSubview(detailView)
    }
    
    // MARK: - Selector
    @objc private func didTapBackButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - SEShowDetailView's implementation
extension SEShowDetailViewController: SEShowDetailView {
    func didRetrieveData(name: String, date: String, genres: String, summary: String, posterData: Data) {
        self.posterImageView.image = UIImage(data: posterData)
        self.addShowInfo(title: "Schedule", detail: date)
        self.addShowInfo(title: "Genres", detail: genres)
        self.addShowInfo(title: "Summary", detail: summary)
        self.collectionViewHeightConstraint?.constant = (UIScreen.main.bounds.height / 7.0) * CGFloat(self.presenter.numberOfSections)
        self.seasonsCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate's methods
extension SEShowDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.showEpisode(from: indexPath)
    }
}
// MARK: - UICollectionViewDatasource's methods
extension SEShowDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.presenter.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.getTotalItems(fromSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SEShowDetailViewController.collectionCellIdentifier, for: indexPath) as? SESeasonCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(from: self.presenter.getEpisode(from: indexPath), section: indexPath.section, delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SEShowDetailViewController.collectionSupplementaryHeaderIdentifier, for: indexPath) as? SESeasonsHeaderCollectionReusableView
            headerView?.setupViews(description: self.presenter.getSectionTitle(section: indexPath.section))
            return headerView ?? (UIView() as! UICollectionReusableView)
        case UICollectionView.elementKindSectionFooter:
            return UIView() as! UICollectionReusableView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 30.0) // you can change sizing here
    }
}

// MARK: - SESeasonCollectionViewCellDelegate's implementation
extension SEShowDetailViewController: SESeasonCollectionViewCellDelegate {
    func didSelectItem(at index: IndexPath) {
        self.presenter.showEpisode(from: index)
    }
}
