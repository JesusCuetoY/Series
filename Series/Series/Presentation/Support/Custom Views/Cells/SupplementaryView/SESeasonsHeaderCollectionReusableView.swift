//
//  SESeasonsHeaderCollectionReusableView.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import UIKit

class SESeasonsHeaderCollectionReusableView: UICollectionReusableView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = SEStylesApp.Color.SE_TextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = .clear
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
                                     self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
                                     self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        SEStylesApp.personalizeLabelBold(self.titleLabel, withSizeFont: 16.0)
    }
    
    func setupViews(description: String) {
        self.titleLabel.text = description
    }
}
