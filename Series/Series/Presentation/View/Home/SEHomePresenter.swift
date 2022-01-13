//
//  SEHomePresenter.swift
//  Series
//
//  Created by Jesus Cueto on 1/13/22.
//

import Foundation

protocol SEHomePresenterInput: AnyObject {
    var showListCount: Int { get }
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
    var showListCount: Int {
        return self.showAuxList.count
    }
    
    init(from interactor: SEShowUseCase, router: SEHomeRouterInput, output: SEHomeView) {
        self.interactor = interactor
        self.router = router
        self.output = output
        self.currentPage = 0
        self.showList = []
        self.showAuxList = []
    }
}

extension SEHomePresenter: SEHomePresenterInput {
    func getShowList() {
        self.interactor.getShows(byPage: "\(self.currentPage)") { [unowned self] showList in
            self.currentPage += 1
            self.showList = self.showList + showList
            self.showAuxList = self.showList
            self.output?.didRetrieveData()
        } failure: { [unowned self] error in
            self.router.routeToError(model: error)
        }
    }
    
    func searchShow(byId id: String) {
        self.interactor.getFilteredShows(from: id) { [unowned self] showList in
            self.showAuxList = showList
            self.output?.didRetrieveData()
        } failure: { [unowned self] error in
            self.router.routeToError(model: error)
        }
    }
    
    func showDetail(from index: IndexPath) {
        self.router.routeToShowDetail(fromID: self.showAuxList[index.row].id)
    }
    
    func getShow(from index: IndexPath) -> SEShowModel {
        return self.showAuxList[index.row]
    }
}
