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
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.isTranslucent = true
        self.navigationBar.barTintColor = .white
        self.navigationBar.backgroundColor = SEStylesApp.Color.SE_PrimaryColor
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: SEStylesApp.Color.SE_TextColor ?? .white]
    }
}
