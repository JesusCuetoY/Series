//
//  SEEpisodeDetailConfigurator.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import Foundation

class SEEpisodeDetailConfigurator {
    
    // MARK: - Properties
    private unowned var viewController: SEEpisodeDetailViewController
    private var episodeInformation: SEShowEpisodeModel
    
    // MARK: - Init
    init(from viewController: SEEpisodeDetailViewController) {
        self.viewController = viewController
        self.episodeInformation = SEShowEpisodeModel()
    }
    
    @discardableResult
    internal func set(episodeInfo info: SEShowEpisodeModel) -> SEEpisodeDetailConfigurator {
        self.episodeInformation = info
        return self
    }
    
    func configure() -> SEEpisodeDetailPresenterInput {
        let request = NetworkManager()
        
        let posterRepository = SEPosterRepository(from: request)
        let interactor = SEPosterInteractor(from: posterRepository)
        
        let router = SEEpisodeDetailRouter(from: self.viewController)
        
        return SEEpisodeDetailPresenter(from: interactor, router: router, output: self.viewController, info: self.episodeInformation)
    }
}
