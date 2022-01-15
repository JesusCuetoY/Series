//
//  SEShowDetailUseCase.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import Foundation

/**
 Protocol that containts the required methodsto procces the Show detail information.
 */
protocol SEShowDetailUseCase: AnyObject {
    /**
     Method that returns all available shows
     - Parameter id: Identifier of a given show.
     - Parameter success: Closure that indicates success state and containts an expected value of  kind`SEShowDetailModel`.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getShowDetail(fromId id: String, success: @escaping(SEShowDetailModel) -> Void, failure: @escaping(SEError) -> Void)
    /**
     Method that returns all available episodes by season
     - Parameter id: Identification key of a season. Ttype `String`.
     - Parameter success: Closure that returns two arrays of type `SEShowEpisodeModel` and  `SEShowEpisodeCellData` based on the results obtained. Default value is empty.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getEpisodesBySeason(id: String, success: @escaping([SEShowEpisodeModel], [SEShowEpisodeCellData]) -> Void, failure: @escaping(SEError) -> Void)
    /**
     Method that returns all available episodes by season
     - Parameter id: Identification key of a season. Ttype `String`.
     - Parameter success: Closure that returns an array of type `SEShowSeasonModel` based on the results obtained. Default value is empty.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getShowSeasons(id: String, success: @escaping([SEShowSeasonModel]) -> Void, failure: @escaping(SEError) -> Void)
}

// MARK: - SEShowDetailInteractor definition
/**
 Class that implements Show's detail use case and process the reveived data.
 */
class SEShowDetailInteractor {
    /// Show's detail repository
    private let repository: SEShowDetailRepositoryProtocol
    /// Poster's repository
    private let posterRepository: SEPosterRepositoryProtocol
    
    init(from repository: SEShowDetailRepositoryProtocol, posterRepository: SEPosterRepositoryProtocol) {
        self.repository = repository
        self.posterRepository = posterRepository
    }
    
    private func makeEpisodesData(from info: [SEShowEpisodeModel], completion: @escaping([SEShowEpisodeCellData]) -> Void) {
        completion(info.map { SEShowEpisodeCellData(fromId: "\($0.id)", number: "\($0.number)", name: $0.name, imagePath: $0.image?.medium ?? SEKeys.MessageKeys.emptyText) })
    }
}

// MARK: - SEShowDetailUseCase's implementation
extension SEShowDetailInteractor: SEShowDetailUseCase {
    func getShowDetail(fromId id: String, success: @escaping (SEShowDetailModel) -> Void, failure: @escaping (SEError) -> Void) {
        self.repository.getShowDetail(fromId: id, success: success, failure: failure)
    }
    
    func getEpisodesBySeason(id: String, success: @escaping([SEShowEpisodeModel], [SEShowEpisodeCellData]) -> Void, failure: @escaping(SEError) -> Void) {
        self.repository.getEpisodesBySeason(id: id, success: { [weak self] episodes in
            self?.makeEpisodesData(from: episodes, completion: { episodesData in
                success(episodes, episodesData)
            })
        }, failure: failure)
    }
    
    func getShowSeasons(id: String, success: @escaping ([SEShowSeasonModel]) -> Void, failure: @escaping (SEError) -> Void) {
        self.repository.getShowSeasons(id: id, success: success, failure: failure)
    }
}

// MARK: - PosterUseCase's implementation
extension SEShowDetailInteractor: SEPosterUseCase {
    func getPoster(fromPath path: String, success: @escaping (Data) -> Void, failure: @escaping (SEError) -> Void) {
        self.posterRepository.getPosterImage(fromPath: path, success: success, failure: failure)
    }
}
