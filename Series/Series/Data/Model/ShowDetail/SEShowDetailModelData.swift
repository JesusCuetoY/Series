//
//  SEShowDetailModelData.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import Foundation

/**
 Data type that represents the season section information of the show.
 */
struct SEShowSeasonModel: Codable {
    /// Season identifier
    let id: Int
    /// Season number
    let number: Int
    /// Season total episodes
    let episodeOrder: Int
}

/**
 Data type that represents the cell initial information of the episode.
 */
struct SEShowEpisodeModel: Codable {
    /// Episode identifier
    let id: Int
    /// Episode name
    let name: String
    /// Episode number
    let number: Int
    /// Episode season
    let season: Int
    /// Episode summary
    let summary: String
    /// Property that contains the poster of medium and large size
    let image: SEShowPosterModel?
    
    init() {
        self.id = 0
        self.name = SEKeys.MessageKeys.emptyText
        self.number = 0
        self.season = 0
        self.summary = SEKeys.MessageKeys.emptyText
        self.image = nil
    }
}
