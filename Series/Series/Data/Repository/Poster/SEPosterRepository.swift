//
//  SEPosterRepository.swift
//  Series
//
//  Created by Jesus Cueto on 1/13/22.
//

import Foundation

// MARK: - SEPosterRepository definition
/**
 Class that implements Poster's repository protocol and pass the network data.
 */
class SEPosterRepository {
    // MARK: - Properties
    /// Property of kind `NetworkManagerProtocol` that is in charge of network management.
    private var request: NetworkManagerProtocol?
    
    init(from request: NetworkManagerProtocol) {
        self.request = request
    }
}

// MARK: - SEPosterRepositoryProtocol implementation
extension SEPosterRepository: SEPosterRepositoryProtocol {
    func getPosterImage(fromPath path: String, success: @escaping (Data) -> Void, failure: @escaping (SEError) -> Void) {
        if path == SEKeys.MessageKeys.emptyText {
            failure(SEError(code: 10004, message: NSLocalizedString(SEKeys.MessageKeys.emptyImage, comment: SEKeys.MessageKeys.emptyText), name: "Error"))
            return
        }
        let url = URL(string: path)!
        self.request?.getRequest(url, returningClass: Data.self, returningError: SEError.self, parameters: nil, success: success, failure: failure)
    }
}
