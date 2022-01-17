//
//  SEPeopleDetailUseCase.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import Foundation

/**
 Protocol that containts the required methodsto procces the Person detail information.
 */
protocol SEPeopleDetailUseCase: AnyObject {
    /**
     Method that returns all available shows
     - Parameter id: Identifier of a given person.
     - Parameter success: Closure that indicates success state and containts an expected value of  kind`SEPeopleModelData`.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getPersonDetail(fromId id: String, success: @escaping(SEPeopleModelData) -> Void, failure: @escaping(SEError) -> Void)
    /**
     Method that returns all available episodes by season
     - Parameter id: Identification key of a season. Ttype `String`.
     - Parameter success: Closure that returns an array of type `SEShowModel` based on the results obtained. Default value is empty.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getRelatedShows(id: String, success: @escaping([SEShowModel]) -> Void, failure: @escaping(SEError) -> Void)
}

// MARK: - SEPeopleDetailInteractor definition
/**
 Class that implements Show's detail use case and process the reveived data.
 */
class SEPeopleDetailInteractor {
    /// Show's detail repository
    private let repository: SEPeopleDetailRepositoryProtocol
    /// Poster's repository
    private let posterRepository: SEPosterRepositoryProtocol
    
    init(from repository: SEPeopleDetailRepositoryProtocol, posterRepository: SEPosterRepositoryProtocol) {
        self.repository = repository
        self.posterRepository = posterRepository
    }
    
    private func makeShowsData(from data: [SEPersonShowsDetailModel], completion: @escaping([SEShowModel]) -> Void) {
        completion(data.map { SEShowModel(id: "\($0.embedInfo.show.id)", name: $0.embedInfo.show.name, poster: $0.embedInfo.show.poster?.medium ?? SEKeys.MessageKeys.emptyText) })
    }
}

// MARK: - SEPeopleDetailUseCase's implementation
extension SEPeopleDetailInteractor: SEPeopleDetailUseCase {
    func getPersonDetail(fromId id: String, success: @escaping (SEPeopleModelData) -> Void, failure: @escaping (SEError) -> Void) {
        self.repository.getPersonDetail(fromId: id, success: success, failure: failure)
    }
    
    func getRelatedShows(id: String, success: @escaping([SEShowModel]) -> Void, failure: @escaping(SEError) -> Void) {
        self.repository.getPersonShows(id: id, success: { [weak self] shows in
            self?.makeShowsData(from: shows, completion: success)
        }, failure: failure)
    }
}

// MARK: - PosterUseCase's implementation
extension SEPeopleDetailInteractor: SEPosterUseCase {
    func getPoster(fromPath path: String, success: @escaping (Data) -> Void, failure: @escaping (SEError) -> Void) {
        self.posterRepository.getPosterImage(fromPath: path, success: success, failure: failure)
    }
}
