//
//  SEPeoplePresenter.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import Foundation

protocol SEPeoplePresenterInput: AnyObject {
    var peopleListCount: Int { get }
    var numberOfSections: Int { get }
    var shimmerListCount: Int { get }
    func getPeopleList()
    func searchPeople(byId id: String)
    func showDetail(from index: IndexPath)
    func getPerson(from index: IndexPath) -> SEPeopleModel
}

class SEPeoplePresenter {
    
    private let interactor: SEPeopleUseCase
    private let router: SEPeopleRouterInput
    private weak var output: SEPeopleView?
    private var currentPage: Int
    private var peopleList: [SEPeopleModel]
    private var peopleAuxList: [SEPeopleModel]
    private var shimmerCount: Int
    var peopleListCount: Int {
        return self.peopleAuxList.count
    }
    var numberOfSections: Int {
        return 2
    }
    var shimmerListCount: Int {
        return shimmerCount
    }
    
    init(from interactor: SEPeopleUseCase, router: SEPeopleRouterInput, output: SEPeopleView) {
        self.interactor = interactor
        self.router = router
        self.output = output
        self.currentPage = 0
        self.shimmerCount = 3
        self.peopleList = []
        self.peopleAuxList = []
    }
}

extension SEPeoplePresenter: SEPeoplePresenterInput {
    func getPeopleList() {
        // If shimmerCount is 0 that means that there is no more pages to load
        if shimmerCount == 0 { return }
        self.interactor.getPeople(byPage: "\(self.currentPage)") { [unowned self] peopleList in
            self.currentPage +=  peopleList.isEmpty ? 0 : 1
            self.shimmerCount = peopleList.isEmpty ? 0 : 3
            self.peopleList = self.peopleList + peopleList
            self.peopleAuxList = self.peopleList
            self.output?.didRetrieveData()
        } failure: { [unowned self] error in
            self.router.routeToError(model: error)
        }
    }
    
    func searchPeople(byId id: String) {
        if id == SEKeys.MessageKeys.emptyText {
            self.shimmerCount = 3
            self.peopleAuxList = self.peopleList
            self.output?.didRetrieveData()
            self.router.routeToHideError()
            return
        }
        self.shimmerCount = 0
        self.interactor.getFilteredPeople(from: id) { [unowned self] showList in
            self.peopleAuxList = showList
            self.output?.didRetrieveData()
            self.router.routeToHideError()
        } failure: { [unowned self] error in
            self.router.routeToEmptyResultError(message: error.message ?? SEKeys.MessageKeys.emptyText)
        }
    }
    
    func showDetail(from index: IndexPath) {
        self.router.routeToPersonDetail(fromID: self.peopleAuxList[index.row].id)
    }
    
    func getPerson(from index: IndexPath) -> SEPeopleModel {
        return self.peopleAuxList[index.row]
    }
}
