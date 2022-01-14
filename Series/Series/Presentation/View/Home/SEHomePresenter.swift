//
//  SEHomePresenter.swift
//  Series
//
//  Created by Jesus Cueto on 1/13/22.
//

import Foundation

protocol SEHomePresenterInput: AnyObject {
    var showListCount: Int { get }
    var numberOfSections: Int { get }
    var shimmerListCount: Int { get }
    func getShowList()
    func searchShow(byId id: String)
    func showDetail(from index: IndexPath)
    func getShow(from index: IndexPath) -> SEShowModel
}

class SEHomePresenter {
    
    private let interactor: SEShowUseCase
    private let router: SEHomeRouterInput
    private weak var output: SEHomeView?
    private var currentPage: Int
    private var showList: [SEShowModel]
    private var showAuxList: [SEShowModel]
    private var shimmerCount: Int
    var showListCount: Int {
        return self.showAuxList.count
    }
    var numberOfSections: Int {
        return 2
    }
    var shimmerListCount: Int {
        return shimmerCount
    }
    
    init(from interactor: SEShowUseCase, router: SEHomeRouterInput, output: SEHomeView) {
        self.interactor = interactor
        self.router = router
        self.output = output
        self.currentPage = 0
        self.shimmerCount = 3
        self.showList = []
        self.showAuxList = []
    }
}

extension SEHomePresenter: SEHomePresenterInput {
    func getShowList() {
        // If shimmerCount is 0 that means that there is no more pages to load
        if shimmerCount == 0 { return }
        self.interactor.getShows(byPage: "\(self.currentPage)") { [unowned self] showList in
            self.currentPage +=  showList.isEmpty ? 0 : 1
            self.shimmerCount = showList.isEmpty ? 0 : 3
            self.showList = self.showList + showList
            self.showAuxList = self.showList
            self.output?.didRetrieveData()
        } failure: { [unowned self] error in
            self.router.routeToError(model: error)
        }
    }
    
    func searchShow(byId id: String) {
        if id == SEKeys.MessageKeys.emptyText {
            self.shimmerCount = 3
            self.showAuxList = self.showList
            self.output?.didRetrieveData()
            self.router.routeToHideError()
            return
        }
        self.shimmerCount = 0
        self.interactor.getFilteredShows(from: id) { [unowned self] showList in
            self.showAuxList = showList
            self.output?.didRetrieveData()
            self.router.routeToHideError()
        } failure: { [unowned self] error in
            self.router.routeToEmptyResultError(message: error.message ?? SEKeys.MessageKeys.emptyText)
        }
    }
    
    func showDetail(from index: IndexPath) {
        self.router.routeToShowDetail(fromID: self.showAuxList[index.row].id)
    }
    
    func getShow(from index: IndexPath) -> SEShowModel {
        return self.showAuxList[index.row]
    }
}
