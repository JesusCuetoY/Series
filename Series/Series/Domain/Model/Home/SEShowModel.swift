//
//  SEShowModel.swift
//  Series
//
//  Created by Jesus Cueto on 1/12/22.
//

import Foundation

protocol SEDisplayModel {
    /// Name of the show.
    var name: String { get set }
    /// Medium image size conainted in `URL` path.
    var poster: String { get set }
}

/**
 Data type that represents the cell initial information of the show.
 */
struct SEShowModel: SEDisplayModel {
    /// Name of the show.
    var name: String
    /// Medium image size conainted in `URL` path.
    var poster: String
    /// id of the show.
    let id: String
    
    init(id: String, name: String, poster: String) {
        self.id = id
        self.name = name
        self.poster = poster
    }
}
