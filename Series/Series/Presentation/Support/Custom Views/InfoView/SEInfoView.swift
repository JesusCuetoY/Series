//
//  SEInfoView.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import UIKit

class SEInfoView: UIView {

    // MARK: - View Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = SEStylesApp.Color.SE_TextColor
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = SEStylesApp.Color.SE_TextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    init(from title: String, description: String, isHTML: Bool) {
        super.init(frame: .infinite)
        self.initView()
        self.titleLabel.text = title
        self.titleLabel.sizeToFit()
        if isHTML {
            do {
                let htmlData = Data(description.utf8)
                let attributedString = try NSMutableAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: SEStylesApp.Color.SE_TextColor!, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .medium)], range: NSRange(location: 0, length: attributedString.length))
                self.descriptionLabel.attributedText = attributedString
            } catch {
                self.descriptionLabel.text = description
            }
        } else {
            self.descriptionLabel.text = description
        }
        self.descriptionLabel.sizeToFit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    // MARK: - Setup
    private func initView() {
        SEStylesApp.personalizeLabelBold(titleLabel, withSizeFont: 14.0)
        SEStylesApp.personalizeLabelMedium(descriptionLabel, withSizeFont: 14.0)
        self.descriptionLabel.textColor = SEStylesApp.Color.SE_TextColor?.withAlphaComponent(0.8)
        self.backgroundColor = .clear
        self.addSubview(self.titleLabel)
        self.addSubview(self.descriptionLabel)
        NSLayoutConstraint.activate([self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
                                     self.titleLabel.trailingAnchor.constraint(equalTo: self.descriptionLabel.leadingAnchor, constant: -12.0),
                                     self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4.0),
                                     self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4.0)])
        NSLayoutConstraint.activate([self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
                                     self.descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4.0),
                                     self.descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4.0)])
    }
    
    internal func setupViews(title: String, detail: String) {
        self.titleLabel.text = title
        self.titleLabel.sizeToFit()
        self.descriptionLabel.text = detail
        self.descriptionLabel.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
