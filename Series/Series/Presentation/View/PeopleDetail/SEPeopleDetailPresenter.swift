//
//  SEPeopleDetailPresenter.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import Foundation

protocol SEPeopleDetailPresenterInput: AnyObject {
    var numberOfSections: Int { get }
    func loadData()
    func goToShowDetail(from index: IndexPath)
    func getShows(from index: IndexPath) -> [SEShowModel]
    func getTotalItems(fromSection section: Int) -> Int
    func getSectionTitle(section: Int) -> String
}

class SEPeopleDetailPresenter {
    
    private let interactor: SEPeopleDetailUseCase & SEPosterUseCase
    private let router: SEPeopleDetailRouterInput
    private weak var output: SEPeopleDetailView?
    private var personInformation: SEPeopleModelData?
    private var shows: [SEShowModel]
    private let personId: String
    private var detailGroup: DispatchGroup
    private var imageData: Data
    var numberOfSections: Int {
        return 1
    }
    
    init(from interactor: SEPeopleDetailUseCase & SEPosterUseCase, router: SEPeopleDetailRouterInput, output: SEPeopleDetailView, id: String) {
        self.interactor = interactor
        self.router = router
        self.output = output
        self.shows = []
        self.personId = id
        self.detailGroup = DispatchGroup()
        self.imageData = Data()
    }
}

extension SEPeopleDetailPresenter: SEPeopleDetailPresenterInput {
    func loadData() {
        self.detailGroup.enter()
        self.interactor.getPersonDetail(fromId: self.personId) { [weak self] personDetail in
            self?.personInformation = personDetail
            self?.interactor.getPoster(fromPath: personDetail.poster?.original ?? SEKeys.MessageKeys.emptyText, success: { [weak self] imgData in
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
        self.interactor.getRelatedShows(id: self.personId) { [weak self] shows in
            self?.shows = shows
            self?.detailGroup.leave()
        } failure: { [weak self] error in
            self?.router.routeToError(model: error)
            self?.detailGroup.leave()
        }
        
        // After all the data is uploaded notify the changes to the view
        self.detailGroup.notify(queue: .main) { [weak self] in
            let birthDay = self?.personInformation?.birthday ?? SEKeys.MessageKeys.emptyText
            let gender = self?.personInformation?.gender ?? SEKeys.MessageKeys.emptyText
            self?.output?.didRetrieveData(name: self?.personInformation?.name ?? SEKeys.MessageKeys.emptyText, birthday: birthDay, gender: gender, posterData: self?.imageData ?? Data())
        }
    }
    
    func goToShowDetail(from index: IndexPath) {
        self.router.routeToShowDetail(from: self.shows[index.row].id)
    }
    
    func getShows(from index: IndexPath) -> [SEShowModel] {
        return self.shows
    }
    
    func getTotalItems(fromSection section: Int) -> Int {
        return 1
    }
    
    func getSectionTitle(section: Int) -> String {
        return "Related Shows"
    }
}
