//
//  SEPosterUseCase.swift
//  Series
//
//  Created by Jesus Cueto on 1/13/22.
//

import Foundation

// MARK: - UseCase definition
/**
 Protocol that defines the use case for every poster required through the app
 */
protocol SEPosterUseCase: AnyObject {
    /**
     Method that gets a image data from a given path
     - Parameter path: Final path that leads to a image
     - Parameter success: Holds a image data if there is one in the `URL` path
     - Parameter failure: Returns an error of type `SEError`
     */
    func getPoster(fromPath path: String, success: @escaping(Data) -> Void, failure: @escaping(SEError) -> Void)
}

// MARK: - Poster Interactor definition
class SEPosterInteractor {
    
    private let repository: SEPosterRepositoryProtocol
    
    init(from repository: SEPosterRepositoryProtocol) {
        self.repository = repository
    }
}

// MARK: - Poster UseCase implementation
extension SEPosterInteractor: SEPosterUseCase {
    func getPoster(fromPath path: String, success: @escaping (Data) -> Void, failure: @escaping (SEError) -> Void) {
        self.repository.getPosterImage(fromPath: path, success: success, failure: failure)
    }
}
