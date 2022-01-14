//
//  SEStylesApp.swift
//  Series
//
//  Created by Jesus Cueto on 1/12/22.
//

import UIKit

// MARK: - Styles Counter App
struct SEStylesApp {
    
    // MARK: - Colors
    struct Color {
        static let SE_PrimaryColor = UIColor(named: "AccentColor")
        static let SE_SecondaryColor = UIColor(named: "SecondaryColor")
        static let SE_TextColor = UIColor(named: "TextColor")
    }
    
    static let buttonCornerRadius: CGFloat = 4.0
    /**
     Method that personalize the label with base Regular Font and a given size.
     - Parameter aLabel: `UILabel` that will be personalized.
     - Parameter aSize: Expected size.
     */
    static func personalizeLabelRegular(_ aLabel: UILabel, withSizeFont aSize: Float) {
        aLabel.font = .systemFont(ofSize: CGFloat(aSize))
    }
    /**
     Method that personalize the label with base Medium Font and a given size.
     - Parameter aLabel: `UILabel` that will be personalized.
     - Parameter aSize: Expected size.
     */
    static func personalizeLabelMedium(_ aLabel: UILabel, withSizeFont aSize: Float) {
        aLabel.font = .systemFont(ofSize: CGFloat(aSize), weight: .medium)
    }
    /**
     Method that personalize the label with base Bold Font and a given size.
     - Parameter aLabel: `UILabel` that will be personalized.
     - Parameter aSize: Expected size.
     */
    static func personalizeLabelBold(_ aLabel: UILabel, withSizeFont aSize: Float) {
        aLabel.font = .systemFont(ofSize: CGFloat(aSize), weight: .bold)
    }
    /**
     Method that personalize the button with a especified base Font and a given size.
     - Parameter button: `UIButton` that will be personalized.
     - Parameter aSize: Expected size.
     - Parameter aBold: Flag that indicates whether the button's title will be Bold or not.
     */
    static func personalizeButtonTitle(_ button: UIButton, withSizeFont aSize: Float, withBold aBold: Bool) {
        button.titleLabel?.font = aBold ? .systemFont(ofSize: CGFloat(aSize), weight: .bold) : .systemFont(ofSize: CGFloat(aSize), weight: .medium)
    }
}
