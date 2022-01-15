//
//  SEShowDetailRepositoryProtocol.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import Foundation

/**
 Protocol that containts the required methods in order to get all the Show's detail information.
 */
protocol SEShowDetailRepositoryProtocol: AnyObject {
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
     - Parameter success: Closure that returns an array of type `SEShowSearchDetailModel` based on the results obtained. Default value is empty.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getEpisodesBySeason(id: String, success: @escaping([SEShowEpisodeModel]) -> Void, failure: @escaping(SEError) -> Void)
    /**
     Method that returns all available episodes by season
     - Parameter id: Identification key of a season. Ttype `String`.
     - Parameter success: Closure that returns an array of type `SEShowSearchDetailModel` based on the results obtained. Default value is empty.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getShowSeasons(id: String, success: @escaping([SEShowSeasonModel]) -> Void, failure: @escaping(SEError) -> Void)
}
