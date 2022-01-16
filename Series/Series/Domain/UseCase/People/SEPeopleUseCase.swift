//
//  SEPeopleUseCase.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import Foundation

// MARK: - SEShowUseCase definition
protocol SEPeopleUseCase: AnyObject {
    /**
     Method that returns all available shows
     - Parameter page: Identifier that indicates the current Show page.
     - Parameter success: Closure that indicates success state and containts an expected list of  kind`SEShowModel`.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getPeople(byPage page: String, success: @escaping([SEPeopleModel]) -> Void, failure: @escaping(SEError) -> Void)
    /**
     Method that returns all available shows that fullfill the required id
     - Parameter id: Identification key of type `String`.
     - Parameter success: Closure that returns an array of type `SEShowModel` based on the results obtained. Default value is empty.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getFilteredPeople(from id: String, success: @escaping([SEPeopleModel]) -> Void, failure: @escaping(SEError) -> Void)
}

// MARK: - SEPeopleInteractor definition
/**
 Class that implements People's use case and process the reveived data.
 */
class SEPeopleInteractor {
    /// Show's repository
    private let repository: SEPeopleRepositoryProtocol
    
    init(from repository: SEPeopleRepositoryProtocol) {
        self.repository = repository
    }
    
    private func makeShowsData(from info: [SEPeopleModelData], completion: @escaping([SEPeopleModel]) -> Void) {
        completion(info.map { SEPeopleModel(id: "\($0.id)", name: $0.name, poster: $0.poster?.medium ?? SEKeys.MessageKeys.emptyText) })
    }
    
    private func makeShowsSearchData(from info: [SEPeopleSearchDetailModel], completion: @escaping([SEPeopleModel]) -> Void) {
        completion(info.map { SEPeopleModel(id: "\($0.person.id)", name: $0.person.name, poster: $0.person.poster?.medium ?? SEKeys.MessageKeys.emptyText) })
    }
}
// MARK: - SEPeopleUseCase's implementation
extension SEPeopleInteractor: SEPeopleUseCase {
    func getPeople(byPage page: String, success: @escaping ([SEPeopleModel]) -> Void, failure: @escaping (SEError) -> Void) {
        self.repository.getPeopleList(byPage: page, success: { [unowned self] people in
            self.makeShowsData(from: people, completion: success)
        }, failure: failure)
    }
    
    func getFilteredPeople(from id: String, success: @escaping ([SEPeopleModel]) -> Void, failure: @escaping (SEError) -> Void) {
        self.repository.getFilteredPeople(from: id, success: { [unowned self] people in
            if people.isEmpty {
                // Means that there is no result from the given ID
                failure(SEError(code: 10001, message: NSLocalizedString(SEKeys.MessageKeys.listSearchEmptyErrorMessage, comment: SEKeys.MessageKeys.emptyText).replacingOccurrences(of: "%@", with: id), name: SEKeys.MessageKeys.emptyText))
                return
            }
            self.makeShowsSearchData(from: people, completion: success)
        }, failure: failure)
    }
}
