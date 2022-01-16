//
//  SEPeopleModel.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import Foundation

/**
 Data type that represents the cell initial information of the show.
 */
struct SEPeopleModel: SEDisplayModel {
    /// Name of the person.
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
