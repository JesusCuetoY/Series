//
//  SEPeopleRepository.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import Foundation

// MARK: - SEPeopleRepository definition
/**
 Class that implements People's repository protocol and pass the network data.
 */
class SEPeopleRepository {
    // MARK: - Static properties
    private static let showPageKey = "page"
    private static let showSearchKey = "q"
    // MARK: - Properties
    /// Property of kind `NetworkManagerProtocol` that is in charge of network management.
    private var request: NetworkManagerProtocol?
    
    init(from request: NetworkManagerProtocol) {
        self.request = request
    }
}

// MARK: - SEPeopleRepositoryProtocol's implementation
extension SEPeopleRepository: SEPeopleRepositoryProtocol {
    func getPeopleList(byPage page: String, success: @escaping ([SEPeopleModelData]) -> Void, failure: @escaping (SEError) -> Void) {
        let url = URL(string: SEKeys.ApiKeys.AppEnvironment.configuration.serverURL + SEKeys.ApiKeys.peopleListURL)!
        self.request?.getRequest(url, returningClass: [SEPeopleModelData].self, returningError: SEError.self, parameters: [SEPeopleRepository.showPageKey: page], success: success, failure: failure)
    }
    
    func getFilteredPeople(from id: String, success: @escaping ([SEPeopleSearchDetailModel]) -> Void, failure: @escaping (SEError) -> Void) {
        let url = URL(string: SEKeys.ApiKeys.AppEnvironment.configuration.serverURL + SEKeys.ApiKeys.peopleSearchURL)!
        self.request?.getRequest(url, returningClass: [SEPeopleSearchDetailModel].self, returningError: SEError.self, parameters: [SEPeopleRepository.showSearchKey: id], success: success, failure: failure)
    }
}
