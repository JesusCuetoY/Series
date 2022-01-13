//
//  SEShowUseCase.swift
//  Series
//
//  Created by Jesus Cueto on 1/12/22.
//

import Foundation

// MARK: - SEShowUseCase definition
protocol SEShowUseCase: AnyObject {
    /**
     Method that returns all available shows
     - Parameter page: Identifier that indicates the current Show page.
     - Parameter success: Closure that indicates success state and containts an expected list of  kind`SEShowModel`.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getShows(byPage page: String, success: @escaping([SEShowModel]) -> Void, failure: @escaping(SEError) -> Void)
    /**
     Method that returns all available shows that fullfill the required id
     - Parameter id: Identification key of type `String`.
     - Parameter success: Closure that returns an array of type `SEShowModel` based on the results obtained. Default value is empty.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getFilteredShows(from id: String, success: @escaping([SEShowModel]) -> Void, failure: @escaping(SEError) -> Void)
}

// MARK: - SEShowInteractor definition
/**
 Class that implements Show's use case and process the reveived data.
 */
class SEShowInteractor {
    /// Show's repository
    private let repository: SEShowRepositoryProtocol
    
    init(from repository: SEShowRepositoryProtocol) {
        self.repository = repository
    }
    
    private func makeShowsData(from info: [SEShowDetailModel], completion: @escaping([SEShowModel]) -> Void) {
        completion(info.map { SEShowModel(id: "\($0.id)", name: $0.name, poster: $0.poster?.medium ?? SEKeys.MessageKeys.emptyText) })
    }
    
    private func makeShowsSearchData(from info: [SEShowSearchDetailModel], completion: @escaping([SEShowModel]) -> Void) {
        completion(info.map { SEShowModel(id: "\($0.show.id)", name: $0.show.name, poster: $0.show.poster?.medium ?? SEKeys.MessageKeys.emptyText) })
    }
}
// MARK: - SEShowUseCase's implementation
extension SEShowInteractor: SEShowUseCase {
    func getShows(byPage page: String, success: @escaping ([SEShowModel]) -> Void, failure: @escaping (SEError) -> Void) {
        self.repository.getShowList(byPage: page, success: { [unowned self] shows in
            self.makeShowsData(from: shows, completion: success)
        }, failure: failure)
    }
    
    func getFilteredShows(from id: String, success: @escaping ([SEShowModel]) -> Void, failure: @escaping (SEError) -> Void) {
        self.repository.getFilteredShows(from: id, success: { [unowned self] shows in
            self.makeShowsSearchData(from: shows, completion: success)
        }, failure: failure)
    }
}
