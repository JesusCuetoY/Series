//
//  SENavigationViewController.swift
//  Series
//
//  Created by Jesus Cueto on 1/12/22.
//

import UIKit

class SENavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBar()
    }
    
    private func configureBar() {
        self.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = SEStylesApp.Color.SE_PrimaryColor
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationController?.navigationBar.compactAppearance = navBarAppearance
        self.navigationBar.barTintColor = SEStylesApp.Color.SE_PrimaryColor
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: SEStylesApp.Color.SE_TextColor ?? .white]
        self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: SEStylesApp.Color.SE_TextColor ?? .white]
    }
}
