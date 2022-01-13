//
//  SEShowRepository.swift
//  Series
//
//  Created by Jesus Cueto on 1/13/22.
//

import Foundation

// MARK: - SEShowRepository definition
/**
 Class that implements Show's repository protocol and pass the network data.
 */
class SEShowRepository {
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

// MARK: - SEShowRepositoryProtocol's implementation
extension SEShowRepository: SEShowRepositoryProtocol {
    func getShowList(byPage page: String, success: @escaping ([SEShowDetailModel]) -> Void, failure: @escaping (SEError) -> Void) {
        let url = URL(string: SEKeys.ApiKeys.AppEnvironment.configuration.serverURL + SEKeys.ApiKeys.showListURL)!
        self.request?.getRequest(url, returningClass: [SEShowDetailModel].self, returningError: SEError.self, parameters: [SEShowRepository.showPageKey: page], success: success, failure: failure)
    }
    
    func getFilteredShows(from id: String, success: @escaping ([SEShowDetailModel]) -> Void, failure: @escaping (SEError) -> Void) {
        let url = URL(string: SEKeys.ApiKeys.AppEnvironment.configuration.serverURL + SEKeys.ApiKeys.showSearchURL)!
        self.request?.getRequest(url, returningClass: [SEShowDetailModel].self, returningError: SEError.self, parameters: [SEShowRepository.showSearchKey: id], success: success, failure: failure)
    }
}
