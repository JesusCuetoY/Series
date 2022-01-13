//
//  ViewController.swift
//  Series
//
//  Created by Jesus Cueto on 1/11/22.
//

import UIKit

class SEHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Shows"
        self.view.backgroundColor = SEStylesApp.Color.SE_SecondaryColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: SEStylesApp.Color.SE_TextColor ?? .white]
    }


}

