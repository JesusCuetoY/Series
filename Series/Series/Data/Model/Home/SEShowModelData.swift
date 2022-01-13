//
//  SEShowModelData.swift
//  Series
//
//  Created by Jesus Cueto on 1/12/22.
//

import Foundation

/**
 Data type that represents a given show from a `JSON` response.
 */
struct SEShowDetailModel: Codable {
    /// Identificaton associated to the show.
    let id: String
    /// Constant that represents name of the show.
    let name: String
    /// Constant that indicates the list of genres of a given show.
    let genres: [String]
    /// Constant that indicates that shedule of the show during a week.
    let schedule: SEShowScheduleModel
    /// Constant that indicates the description of the show.
    let summary: String
    /// Data structure that contains the show's main image as URL.
    let poster: SEShowPosterModel
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case genres
        case schedule
        case summary
        case poster = "image"
    }
}

/**
 Data type that represents the shedule of the show during a week.
 */
struct SEShowScheduleModel: Codable {
    /// Exactly time during the day when the show start.
    let time: String
    /// Group of days where the show is streamed.
    let days: [String]
}

/**
 Data type that represents the poster in original and medium size.
 */
struct SEShowPosterModel: Codable {
    /// `URL` path that contains the original size of the show's poster.
    let original: String
    /// `URL` path that contains a reduced image size of the show's poster.
    let medium: String
}
