//
//  SEShowDetailRepository.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import Foundation

// MARK: - SEShowDetailRepository definition
/**
 Class that implements Show details repository protocol and pass the network data.
 */
class SEShowDetailRepository {
    // MARK: - Properties
    /// Property of kind `NetworkManagerProtocol` that is in charge of network management.
    private var request: NetworkManagerProtocol?
    
    init(from request: NetworkManagerProtocol) {
        self.request = request
    }
}

// MARK: - SEShowDetailRepositoryProtocol implementation
extension SEShowDetailRepository: SEShowDetailRepositoryProtocol {
    func getShowDetail(fromId id: String, success: @escaping (SEShowDetailModel) -> Void, failure: @escaping (SEError) -> Void) {
        let url = URL(string: SEKeys.ApiKeys.AppEnvironment.configuration.serverURL + SEKeys.ApiKeys.showListURL + "/" + id)!
        self.request?.getRequest(url, returningClass: SEShowDetailModel.self, returningError: SEError.self, parameters: nil, success: success, failure: failure)
    }
    
    func getEpisodesBySeason(id: String, success: @escaping ([SEShowEpisodeModel]) -> Void, failure: @escaping (SEError) -> Void) {
        let url = URL(string: SEKeys.ApiKeys.AppEnvironment.configuration.serverURL + SEKeys.ApiKeys.showSeasonsURL + "/\(id)/" + SEKeys.ApiKeys.showEpisodesURL)!
        self.request?.getRequest(url, returningClass: [SEShowEpisodeModel].self, returningError: SEError.self, parameters: nil, success: success, failure: failure)
    }
    
    func getShowSeasons(id: String, success: @escaping ([SEShowSeasonModel]) -> Void, failure: @escaping (SEError) -> Void) {
        let url = URL(string: SEKeys.ApiKeys.AppEnvironment.configuration.serverURL + SEKeys.ApiKeys.showListURL + "/\(id)/" + SEKeys.ApiKeys.showSeasonsURL)!
        self.request?.getRequest(url, returningClass: [SEShowSeasonModel].self, returningError: SEError.self, parameters: nil, success: success, failure: failure)
    }
}
