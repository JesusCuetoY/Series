//
//  SEPeopleConfigurator.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import Foundation

class SEPeopleConfigurator {
    private unowned var viewController: SEPeopleViewController
    
    init(from viewController: SEPeopleViewController) {
        self.viewController = viewController
    }
    
    func configure() -> SEPeoplePresenterInput {
        let request = NetworkManager()
        
        let repository = SEPeopleRepository(from: request)
        let interactor = SEPeopleInteractor(from: repository)
        
        let router = SEPeopleRouter(from: self.viewController)
        
        return SEPeoplePresenter(from: interactor, router: router, output: self.viewController)
    }
}
