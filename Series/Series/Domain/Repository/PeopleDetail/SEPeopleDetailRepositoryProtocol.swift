//
//  SEPeopleDetailRepositoryProtocol.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import Foundation

/**
 Protocol that containts the required methods in order to get all the Person's detail information.
 */
protocol SEPeopleDetailRepositoryProtocol: AnyObject {
    /**
     Method that returns all available shows
     - Parameter id: Identifier of a given person.
     - Parameter success: Closure that indicates success state and containts an expected value of  kind`SEPeopleModelData`.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getPersonDetail(fromId id: String, success: @escaping(SEPeopleModelData) -> Void, failure: @escaping(SEError) -> Void)
    /**
     Method that returns all available episodes by season
     - Parameter id: Identification key of a Person. Ttype `String`.
     - Parameter success: Closure that returns an array of type `SEPersonShowsDetailModel` based on the results obtained. Default value is empty.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getPersonShows(id: String, success: @escaping([SEPersonShowsDetailModel]) -> Void, failure: @escaping(SEError) -> Void)
}
