//
//  SEShowModel.swift
//  Series
//
//  Created by Jesus Cueto on 1/12/22.
//

import Foundation

/**
 Data type that represents the cell initial information of the show.
 */
struct SEShowModel: Codable {
    /// id of the show.
    let id: String
    /// Name of the show.
    let name: String
    /// Medium image size conainted in `URL` path.
    let poster: String
    
    init(id: String, name: String, poster: String) {
        self.id = id
        self.name = name
        self.poster = poster
    }
}
