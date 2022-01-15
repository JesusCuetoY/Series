//
//  SEShowDetailModel.swift
//  Series
//
//  Created by Jesus Cueto on 1/14/22.
//

import Foundation

/**
 Data type that represents the cell initial information of the episode.
 */
struct SEShowEpisodeCellData: SEDisplayModel {
    /// Episode identifier
    let id: String
    /// Episode number
    let number: String
    /// Episode name
    var name: String
    /// Episode medium image path
    var poster: String
    
    init(fromId id: String, number: String, name: String, imagePath: String) {
        self.id = id
        self.number = number
        self.name = name
        self.poster = imagePath
    }
}
