//
//  SEEpisodeDetailPresenter.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import Foundation

protocol SEEpisodeDetailPresenterInput: AnyObject {
    func loadData()
    func goToShowDetail()
}

class SEEpisodeDetailPresenter {
    
    private let interactor: SEPosterUseCase
    private let router: SEEpisodeDetailRouterInput
    private weak var output: SEEpisodeDetailView?
    private var episodeInformation: SEShowEpisodeModel?
    
    init(from interactor: SEPosterUseCase, router: SEEpisodeDetailRouterInput, output: SEEpisodeDetailView, info: SEShowEpisodeModel) {
        self.interactor = interactor
        self.router = router
        self.output = output
        self.episodeInformation = info
    }
}

extension SEEpisodeDetailPresenter: SEEpisodeDetailPresenterInput {
    func loadData() {
        self.interactor.getPoster(fromPath: self.episodeInformation?.image?.original ?? SEKeys.MessageKeys.emptyText) { [weak self] imgData in
            self?.output?.didRetrieveData(name: self?.episodeInformation?.name ?? SEKeys.MessageKeys.emptyText, number: "\(self?.episodeInformation?.number ?? 0)", season: "\(self?.episodeInformation?.season ?? 0)", summary: self?.episodeInformation?.summary ?? SEKeys.MessageKeys.emptyText, posterData: imgData)
        } failure: { [weak self] error in
            self?.router.routeToError(model: error)
        }
    }
    
    func goToShowDetail() {
        self.router.routeToShow()
    }
}
