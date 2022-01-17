//
//  SEPeopleDetailConfigurator.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import Foundation

class SEPeopleDetailConfigurator {
    
    // MARK: - Properties
    private unowned var viewController: SEPeopleDetailViewController
    private var peopleId: String
    
    // MARK: - Init
    init(from viewController: SEPeopleDetailViewController) {
        self.viewController = viewController
        self.peopleId = SEKeys.MessageKeys.emptyText
    }
    
    @discardableResult
    internal func set(personId id: String) -> SEPeopleDetailConfigurator {
        self.peopleId = id
        return self
    }
    
    func configure() -> SEPeopleDetailPresenterInput {
        let request = NetworkManager()
        
        let repository = SEPeopleDetailRepository(from: request)
        let posterRepository = SEPosterRepository(from: request)
        let interactor = SEPeopleDetailInteractor(from: repository, posterRepository: posterRepository)
        
        let router = SEPeopleDetailRouter(from: self.viewController)
        
        return SEPeopleDetailPresenter(from: interactor, router: router, output: self.viewController, id: self.peopleId)
    }
}
