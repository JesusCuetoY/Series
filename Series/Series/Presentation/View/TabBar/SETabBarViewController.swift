//
//  SETabBarViewController.swift
//  Series
//
//  Created by Jesus Cueto on 1/15/22.
//

import UIKit

/// The main TabBarController for the application. This controls the setup of the tab bar.
class SETabBarViewController: UITabBarController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initView()
        self.addTabs()
    }
    
    // MARK: - Setup
    private func initView() {
        self.tabBar.isTranslucent = true
        self.tabBar.backgroundColor = SEStylesApp.Color.SE_PrimaryColor
        let appearance = UIBarAppearance()
        appearance.backgroundColor = SEStylesApp.Color.SE_PrimaryColor
        appearance.configureWithTransparentBackground()
        self.tabBar.tintColor = SEStylesApp.Color.SE_TextColor
        self.tabBar.standardAppearance = .init(barAppearance: appearance)
    }
    
    private func addTabs() {
        let showsViewController = SEHomeViewController()
        let peopleViewController = SEPeopleViewController()
        self.addChild(self.tabNavigationController("Series", imageName: "book", showsViewController))
        self.addChild(self.tabNavigationController("People", imageName: "person.2.fill", peopleViewController))
    }
    
    // MARK: - Factory
    private func tabNavigationController(_ title: String, imageName: String, _ rootViewController: UIViewController) -> UINavigationController {
        let image = UIImage(systemName: imageName)
        image?.withTintColor(SEStylesApp.Color.SE_TextColor ?? .white, renderingMode: .alwaysTemplate)
        let selectedImage = UIImage(systemName: imageName)
        selectedImage?.withTintColor(SEStylesApp.Color.SE_SecondaryColor ?? .black, renderingMode: .alwaysTemplate)
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        tabBarItem.isAccessibilityElement = true
        tabBarItem.accessibilityLabel = title
        tabBarItem.accessibilityIdentifier = "Tab:\(title)"
        
        let navController = SENavigationViewController(rootViewController: rootViewController)
        navController.tabBarItem = tabBarItem
                
        return navController
    }
}
