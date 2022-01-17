//
//  SEPersonShowsDetailModel.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import Foundation

/**
 Data type that represents the embedded information section information of the show.
 */
struct SEPersonShowsDetailModel: Codable {
    let embedInfo: SEEmbedInformation
    
    private enum CodingKeys: String, CodingKey {
        case embedInfo = "_embedded"
    }
}

/**
 Data type that represents the embedded information section information of the show.
 */
struct SEEmbedInformation: Codable {
    /// Show info
    let show: SEShowDetailModel
}
