//
//  SEPosterRepositoryProtocol.swift
//  Series
//
//  Created by Jesus Cueto on 1/13/22.
//

import Foundation

/**
 Protocol that containts the required methods in order to get a given poster.
 */
protocol SEPosterRepositoryProtocol: AnyObject {
    /**
     Method that returns all available shows
     - Parameter path: Identifier that indicates the path of a Poster. It will be transformed to a final `URL`
     - Parameter success: Closure that indicates success state and containts an expected value of  kind`Data`.
     - Parameter failure: Closure that indicates failure state and containts an expected value of `SEError`.
     */
    func getPosterImage(fromPath path: String, success: @escaping(Data) -> Void, failure: @escaping(SEError) -> Void)
}
