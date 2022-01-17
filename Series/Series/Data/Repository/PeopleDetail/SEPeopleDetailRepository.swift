//
//  SEPeopleDetailRepository.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import Foundation

// MARK: - SEPeopleDetailRepository definition
/**
 Class that implements Person details repository protocol and pass the network data.
 */
class SEPeopleDetailRepository {
    // MARK: - Properties
    /// Property of kind `NetworkManagerProtocol` that is in charge of network management.
    private var request: NetworkManagerProtocol?
    private static let embedKey = "embed"
    private static let embedValue = "show"
    
    init(from request: NetworkManagerProtocol) {
        self.request = request
    }
}

// MARK: - SEShowDetailRepositoryProtocol implementation
extension SEPeopleDetailRepository: SEPeopleDetailRepositoryProtocol {
    func getPersonDetail(fromId id: String, success: @escaping (SEPeopleModelData) -> Void, failure: @escaping (SEError) -> Void) {
        let url = URL(string: SEKeys.ApiKeys.AppEnvironment.configuration.serverURL + SEKeys.ApiKeys.peopleListURL + "/" + id)!
        self.request?.getRequest(url, returningClass: SEPeopleModelData.self, returningError: SEError.self, parameters: nil, success: success, failure: failure)
    }
    
    func getPersonShows(id: String, success: @escaping ([SEPersonShowsDetailModel]) -> Void, failure: @escaping (SEError) -> Void) {
        let url = URL(string: SEKeys.ApiKeys.AppEnvironment.configuration.serverURL + SEKeys.ApiKeys.peopleListURL + "/\(id)/" + SEKeys.ApiKeys.peopleShowsURL)!
        self.request?.getRequest(url, returningClass: [SEPersonShowsDetailModel].self, returningError: SEError.self, parameters: [Self.embedKey: Self.embedValue], success: success, failure: failure)
    }
}
