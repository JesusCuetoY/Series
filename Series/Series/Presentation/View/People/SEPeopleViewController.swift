//
//  SEPeopleViewController.swift
//  Series
//
//  Created by Jesus Cueto on 1/15/22.
//

import UIKit

protocol SEPeopleView: AnyObject {
    func didRetrieveData()
}

class SEPeopleViewController: UIViewController {
    
    // MARK: - Views
    internal lazy var showCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 20.0, right: 0.0)
        layout.minimumInteritemSpacing = 0.0
        let itemWidth = UIScreen.main.bounds.width/3.0
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 10.0)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SEShowCollectionViewCell.self, forCellWithReuseIdentifier: SEPeopleViewController.collectionCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    internal lazy var searchResultErrorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = SEStylesApp.Color.SE_TextColor?.withAlphaComponent(0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var searchBar: UISearchController = {
        let bar = UISearchController(searchResultsController: nil)
        bar.searchBar.tintColor = SEStylesApp.Color.SE_PrimaryColor
        bar.searchBar.placeholder = NSLocalizedString(SEKeys.MessageKeys.listSearchPlaceholder, comment: SEKeys.MessageKeys.emptyText)
        bar.searchResultsUpdater = self
        bar.delegate = self
        bar.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        return bar
    }()
    // MARK: - Properties
    private lazy var configurator: SEPeopleConfigurator = { return SEPeopleConfigurator(from: self) }()
    private lazy var presenter: SEPeoplePresenterInput = { return self.configurator.configure() }()
    private static let controllerName: String = "People"
    private static let collectionCellIdentifier: String = "showCell"

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func initView() {
        self.title = SEPeopleViewController.controllerName
        self.navigationItem.searchController = self.searchBar
        self.view.backgroundColor = SEStylesApp.Color.SE_SecondaryColor
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = SEStylesApp.Color.SE_PrimaryColor
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.view.addSubview(self.showCollectionView)
        NSLayoutConstraint.activate([self.showCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     self.showCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     self.showCollectionView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
                                     self.showCollectionView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor)])
        self.view.addSubview(self.searchResultErrorLabel)
        NSLayoutConstraint.activate([self.searchResultErrorLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                     self.searchResultErrorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     self.searchResultErrorLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8)])
        self.searchResultErrorLabel.isHidden = true
        self.presenter.getPeopleList()
    }
}

// MARK: - SEHomeView's methods
extension SEPeopleViewController: SEPeopleView {
    func didRetrieveData() {
        self.showCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate's methods
extension SEPeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.showDetail(from: indexPath)
    }
}
// MARK: - UICollectionViewDatasource's methods
extension SEPeopleViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.presenter.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.presenter.peopleListCount
        case 1:
            return self.presenter.shimmerListCount
        default:
            return self.presenter.peopleListCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SEPeopleViewController.collectionCellIdentifier, for: indexPath) as? SEShowCollectionViewCell else {
            return UICollectionViewCell()
        }
        switch indexPath.section {
        case 0: cell.setupCell(from: self.presenter.getPerson(from: indexPath))
        case 1: cell.setupShimmerCell()
        default: cell.setupCell(from: self.presenter.getPerson(from: indexPath))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.presenter.shimmerListCount - 1 && indexPath.section == 1 && !self.searchBar.searchBar.searchTextField.isFirstResponder {
            self.presenter.getPeopleList()
        }
    }
}

// MARK: - UISearchResultsUpdating's method
extension SEPeopleViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.presenter.searchPeople(byId: searchController.searchBar.searchTextField.text ?? SEKeys.MessageKeys.emptyText)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.presenter.searchPeople(byId: SEKeys.MessageKeys.emptyText)
    }
}
