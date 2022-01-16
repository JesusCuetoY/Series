//
//  SEPeopleDetailViewController.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import UIKit

protocol SEPeopleDetailView: AnyObject {
    func didRetrieveData(name: String, birthday: String, gender: String, posterData: Data)
}

class SEPeopleDetailViewController: UIViewController {

    // MARK: - View's Properties
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "ic_placeholder")
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
        button.isHidden = true
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
    private lazy var showsCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 20.0, right: 0.0)
        layout.minimumInteritemSpacing = 0.0
        let itemWidth = UIScreen.main.bounds.width
        layout.headerReferenceSize = CGSize(width: itemWidth, height: 30.0)
        layout.itemSize = CGSize(width: itemWidth, height: UIScreen.main.bounds.height / 7.0)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SESeasonCollectionViewCell.self, forCellWithReuseIdentifier: SEPeopleDetailViewController.collectionCellIdentifier)
        collectionView.register(SESeasonsHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SEPeopleDetailViewController.collectionSupplementaryHeaderIdentifier)
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
    
    // MARK: - Properties
    private static let collectionCellIdentifier: String = "seasonCell"
    private static let collectionSupplementaryHeaderIdentifier: String = "seasonHeader"
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    internal lazy var configurator: SEPeopleDetailConfigurator = { return SEPeopleDetailConfigurator(from: self) }()
    private lazy var presenter: SEPeopleDetailPresenterInput = { return self.configurator.configure() }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initView()
        self.presenter.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradient.frame = self.gradientView.frame
    }
    
    // MARK: - InitView
    private func initView() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = SEStylesApp.Color.SE_SecondaryColor
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.posterImageView)
        self.contentView.addSubview(self.backButton)
        self.contentView.addSubview(self.vInfoStack)
        self.contentView.addSubview(showsCollectionView)
        self.posterImageView.addSubview(self.gradientView)
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
                                     self.vInfoStack.bottomAnchor.constraint(equalTo: self.showsCollectionView.topAnchor, constant: -16.0)])
        // ColectionView
        self.collectionViewHeightConstraint = self.showsCollectionView.heightAnchor.constraint(equalToConstant: 100.0)
        NSLayoutConstraint.activate([self.showsCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                                     self.showsCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                                     self.showsCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16.0),
                                     self.collectionViewHeightConstraint!])
        // Gradient View
        NSLayoutConstraint.activate([self.gradientView.topAnchor.constraint(equalTo: self.posterImageView.topAnchor),
                                     self.gradientView.bottomAnchor.constraint(equalTo: self.posterImageView.bottomAnchor),
                                     self.gradientView.leadingAnchor.constraint(equalTo: self.posterImageView.leadingAnchor),
                                     self.gradientView.trailingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor)])
        self.gradientView.layer.insertSublayer(gradient, at: 0)
        self.posterImageView.bringSubviewToFront(gradientView)
    }
    
    private func addShowInfo(title: String, detail: String, isHTML: Bool) {
        let detailView: SEInfoView = SEInfoView(from: title, description: detail, isHTML: isHTML)
        self.vInfoStack.addArrangedSubview(detailView)
    }
    
    // MARK: - Selector
    @objc private func didTapBackButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - SEPeopleDetailView's implementation
extension SEPeopleDetailViewController: SEPeopleDetailView {
    func didRetrieveData(name: String, birthday: String, gender: String, posterData: Data) {
        self.title = name
        self.posterImageView.image = UIImage(data: posterData)
        self.addShowInfo(title: "Birthday: ", detail: birthday, isHTML: false)
        self.addShowInfo(title: "Gender: ", detail: gender, isHTML: false)
        self.collectionViewHeightConstraint?.constant = ((UIScreen.main.bounds.height / 7.0) * CGFloat(self.presenter.numberOfSections) + (30.0 * CGFloat(self.presenter.numberOfSections)))
        self.showsCollectionView.dataSource = self
        self.showsCollectionView.delegate = self
        self.showsCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate's methods
extension SEPeopleDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - UICollectionViewDatasource's methods
extension SEPeopleDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.presenter.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.getTotalItems(fromSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SEPeopleDetailViewController.collectionCellIdentifier, for: indexPath) as? SESeasonCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(from: self.presenter.getShows(from: indexPath), section: indexPath.section, delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SEPeopleDetailViewController.collectionSupplementaryHeaderIdentifier, for: indexPath) as? SESeasonsHeaderCollectionReusableView
            headerView?.setupViews(description: self.presenter.getSectionTitle(section: indexPath.section))
            return headerView ?? (UIView() as! UICollectionReusableView)
        case UICollectionView.elementKindSectionFooter:
            return UIView() as! UICollectionReusableView
        default:
            return UIView() as! UICollectionReusableView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 30.0)
    }
}

// MARK: - SESeasonCollectionViewCellDelegate's implementation
extension SEPeopleDetailViewController: SESeasonCollectionViewCellDelegate {
    func didSelectItem(at index: IndexPath) {
        self.presenter.goToShowDetail(from: index)
    }
}
