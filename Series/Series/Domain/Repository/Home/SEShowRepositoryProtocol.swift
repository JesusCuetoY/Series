//
//  SEShowRepositoryProtocol.swift
//  Series
//
//  Created by Jesus Cueto on 1/12/22.
//

import Foundation
/**
 Protocol that containts the required methods in order to get all the Show's information.
 */
protocol SEShowRepositoryProtocol: AnyObject {
    /**
     Method that returns all available shows
     - Parameter page: Identifier that indicates the current Show page.
     - Parameter success: Closure that indicates success state and containts an expected list of  kind`SEShowDetailModel`.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getShowList(byPage page: String, success: @escaping([SEShowDetailModel]) -> Void, failure: @escaping(SEError) -> Void)
    /**
     Method that returns all available shows that fullfill the required id
     - Parameter id: Identification key of type `String`.
     - Parameter success: Closure that returns an array of type `SEShowDetailModel` based on the results obtained. Default value is empty.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getFilteredShows(from id: String, success: @escaping([SEShowDetailModel]) -> Void, failure: @escaping(SEError) -> Void)
}
