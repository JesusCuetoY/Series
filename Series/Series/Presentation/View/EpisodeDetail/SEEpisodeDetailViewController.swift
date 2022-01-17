//
//  SEEpisodeDetailViewController.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import UIKit

protocol SEEpisodeDetailView: AnyObject {
    func didRetrieveData(name: String, number: String, season: String, summary: String, posterData: Data)
}

class SEEpisodeDetailViewController: UIViewController {

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
    internal lazy var configurator: SEEpisodeDetailConfigurator = { return SEEpisodeDetailConfigurator(from: self) }()
    private lazy var presenter: SEEpisodeDetailPresenterInput = { return self.configurator.configure() }()
    
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
        self.view.backgroundColor = SEStylesApp.Color.SE_SecondaryColor
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.posterImageView)
        self.contentView.addSubview(self.backButton)
        self.contentView.addSubview(self.vInfoStack)
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
                                     self.vInfoStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16.0)])
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
        self.presenter.goToShowDetail()
    }
}

// MARK: - SEEpisodeDetailView's implementation
extension SEEpisodeDetailViewController: SEEpisodeDetailView {
    func didRetrieveData(name: String, number: String, season: String, summary: String, posterData: Data) {
        self.posterImageView.image = UIImage(data: posterData)
        self.title = name
        self.addShowInfo(title: "Season: ", detail: season, isHTML: false)
        self.addShowInfo(title: "Number: ", detail: number, isHTML: false)
        self.addShowInfo(title: SEKeys.MessageKeys.emptyText, detail: summary, isHTML: true)
    }
}
