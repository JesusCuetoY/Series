//
//  SEShowDetailConfigurator.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import Foundation

class SEShowDetailConfigurator {
    
    // MARK: - Properties
    private unowned var viewController: SEShowDetailViewController
    private var showId: String
    
    // MARK: - Init
    init(from viewController: SEShowDetailViewController) {
        self.viewController = viewController
        self.showId = SEKeys.MessageKeys.emptyText
    }
    
    @discardableResult
    internal func set(showId id: String) -> SEShowDetailConfigurator {
        self.showId = id
        return self
    }
    
    func configure() -> SEShowDetailPresenterInput {
        let request = NetworkManager()
        
        let repository = SEShowDetailRepository(from: request)
        let posterRepository = SEPosterRepository(from: request)
        let interactor = SEShowDetailInteractor(from: repository, posterRepository: posterRepository)
        
        let router = SEShowDetailRouter(from: self.viewController)
        
        return SEShowDetailPresenter(from: interactor, router: router, output: self.viewController, id: self.showId)
    }
}
