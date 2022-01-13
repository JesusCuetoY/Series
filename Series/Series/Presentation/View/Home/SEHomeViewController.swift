//
//  ViewController.swift
//  Series
//
//  Created by Jesus Cueto on 1/11/22.
//

import UIKit

protocol SEHomeView: AnyObject {
    func didRetrieveData()
}

class SEHomeViewController: UIViewController {
    
    // MARK: - Views
    private lazy var showCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 20.0, right: 0.0)
        layout.minimumInteritemSpacing = 0.0
        let itemWidth = UIScreen.main.bounds.width/3.0
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 10.0)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SEShowCollectionViewCell.self, forCellWithReuseIdentifier: SEHomeViewController.collectionCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
    private lazy var configurator: SEHomeConfigurator = { return SEHomeConfigurator(from: self) }()
    private lazy var presenter: SEHomePresenterInput = { return self.configurator.configure() }()
    private static let controllerName: String = "Shows"
    private static let collectionCellIdentifier: String = "showCell"

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initView()
    }
    
    private func initView() {
        self.title = SEHomeViewController.controllerName
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
        self.presenter.getShowList()
    }
}

// MARK: - SEHomeView's methods
extension SEHomeViewController: SEHomeView {
    func didRetrieveData() {
        self.showCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate's methods
extension SEHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.showDetail(from: indexPath)
    }
}
// MARK: - UICollectionViewDatasource's methods
extension SEHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.showListCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SEHomeViewController.collectionCellIdentifier, for: indexPath) as? SEShowCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(from: self.presenter.getShow(from: indexPath))
        return cell
    }
}

// MARK: - UISearchResultsUpdating's method
extension SEHomeViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.presenter.searchShow(byId: searchController.searchBar.searchTextField.text ?? SEKeys.MessageKeys.emptyText)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.presenter.searchShow(byId: SEKeys.MessageKeys.emptyText)
    }
}
