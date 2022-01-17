//
//  SEHomeConfigurator.swift
//  Series
//
//  Created by Jesus Cueto on 1/13/22.
//

import Foundation

class SEHomeConfigurator {
    private unowned var viewController: SEHomeViewController
    
    init(from viewController: SEHomeViewController) {
        self.viewController = viewController
    }
    
    func configure() -> SEHomePresenterInput {
        let request = NetworkManager()
        
        let repository = SEShowRepository(from: request)
        let interactor = SEShowInteractor(from: repository)
        
        let router = SEHomeRouter(from: self.viewController)
        
        return SEHomePresenter(from: interactor, router: router, output: self.viewController)
    }
}
