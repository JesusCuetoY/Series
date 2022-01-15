//
//  SEShowDetailPresenter.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import Foundation

protocol SEShowDetailPresenterInput: AnyObject {
    var numberOfSections: Int { get }
    func loadData()
    func showEpisode(from index: IndexPath)
    func getEpisode(from index: IndexPath) -> [SEShowEpisodeCellData]
    func getTotalItems(fromSection section: Int) -> Int
    func getSectionTitle(section: Int) -> String
    func goToEpisode(from index: IndexPath)
}

class SEShowDetailPresenter {
    
    private let interactor: SEShowDetailUseCase & SEPosterUseCase
    private let router: SEShowDetailRouterInput
    private weak var output: SEShowDetailView?
    private var showInformation: SEShowDetailModel?
    private var seasons: [SEShowSeasonModel]
    private var episodesBySeason: [[SEShowEpisodeModel]]
    private var episodesBySeasonData: [[SEShowEpisodeCellData]]
    private let showDetaildentifier: String
    private var detailGroup: DispatchGroup
    private var imageData: Data
    var numberOfSections: Int {
        return episodesBySeason.count
    }
    
    init(from interactor: SEShowDetailUseCase & SEPosterUseCase, router: SEShowDetailRouterInput, output: SEShowDetailView, id: String) {
        self.interactor = interactor
        self.router = router
        self.output = output
        self.seasons = []
        self.episodesBySeason = []
        self.episodesBySeasonData = []
        self.showDetaildentifier = id
        self.detailGroup = DispatchGroup()
        self.imageData = Data()
    }
    
    private func makeEpisodesData(from seasons: [SEShowSeasonModel], completion: @escaping() -> Void) {
        let episodesGroup = DispatchGroup()
        for season in seasons {
            episodesGroup.enter()
            self.interactor.getEpisodesBySeason(id: "\(season.id)") { [weak self] episodeList, episodeListData in
                self?.episodesBySeason.append(episodeList)
                self?.episodesBySeasonData.append(episodeListData)
                episodesGroup.leave()
            } failure: { [weak self] _ in
                self?.episodesBySeason.append([])
                self?.episodesBySeasonData.append([])
                episodesGroup.leave()
            }
        }
        episodesGroup.notify(queue: .main) {
            completion()
        }
    }
}

extension SEShowDetailPresenter: SEShowDetailPresenterInput {
    func loadData() {
        self.detailGroup.enter()
        self.interactor.getShowDetail(fromId: self.showDetaildentifier) { [weak self] showDetail in
            self?.showInformation = showDetail
            self?.interactor.getPoster(fromPath: showDetail.poster?.original ?? SEKeys.MessageKeys.emptyText, success: { [weak self] imgData in
                self?.imageData = imgData
                self?.detailGroup.leave()
            }, failure: { [weak self] error in
                self?.router.routeToError(model: error)
                self?.detailGroup.leave()
            })
        } failure: { [weak self] error in
            self?.router.routeToError(model: error)
            self?.detailGroup.leave()
        }
        
        self.detailGroup.enter()
        self.interactor.getShowSeasons(id: self.showDetaildentifier) { [weak self] seasons in
            self?.seasons = seasons
            self?.makeEpisodesData(from: seasons, completion: { [weak self] in
                self?.detailGroup.leave()
            })
        } failure: { [weak self] error in
            self?.router.routeToError(model: error)
            self?.detailGroup.leave()
        }
        
        // After all the data is uploaded notify the changes to the view
        self.detailGroup.notify(queue: .main) { [weak self] in
            let days = self?.showInformation?.schedule?.days.joined(separator: " ") ?? SEKeys.MessageKeys.emptyText
            let schedule = self?.showInformation?.schedule?.time ?? SEKeys.MessageKeys.emptyText
            self?.output?.didRetrieveData(name: self?.showInformation?.name ?? SEKeys.MessageKeys.emptyText, date: schedule + days, genres: self?.showInformation?.genres.joined(separator: " ") ?? SEKeys.MessageKeys.emptyText, summary: self?.showInformation?.summary ?? SEKeys.MessageKeys.emptyText, posterData: self?.imageData ?? Data())
        }
    }
    
    func showEpisode(from index: IndexPath) {
        self.router.routeToShowEpisodeDetail(from: self.episodesBySeason[index.section][index.row])
    }
    
    func getEpisode(from index: IndexPath) -> [SEShowEpisodeCellData] {
        return self.episodesBySeasonData[index.section]
    }
    
    func getTotalItems(fromSection section: Int) -> Int {
        return 1
    }
    
    func getSectionTitle(section: Int) -> String {
        return "Season \(self.seasons[section].number)"
    }
    
    func goToEpisode(from index: IndexPath) {
        self.router.routeToShowEpisodeDetail(from: self.episodesBySeason[index.section][index.row])
    }
}
