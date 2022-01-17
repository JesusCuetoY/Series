//
//  SEPeopleRepositoryProtocol.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import Foundation

/**
 Protocol that containts the required methods in order to get all the Person's information.
 */
protocol SEPeopleRepositoryProtocol: AnyObject {
    /**
     Method that returns all available shows
     - Parameter page: Identifier that indicates the current People page.
     - Parameter success: Closure that indicates success state and containts an expected list of  kind`SEPeopleModelData`.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getPeopleList(byPage page: String, success: @escaping([SEPeopleModelData]) -> Void, failure: @escaping(SEError) -> Void)
    /**
     Method that returns all available shows that fullfill the required id
     - Parameter id: Identification key of type `String`.
     - Parameter success: Closure that returns an array of type `SEPeopleSearchDetailModel` based on the results obtained. Default value is empty.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getFilteredPeople(from id: String, success: @escaping([SEPeopleSearchDetailModel]) -> Void, failure: @escaping(SEError) -> Void)
}
