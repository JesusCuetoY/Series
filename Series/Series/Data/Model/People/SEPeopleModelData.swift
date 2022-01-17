//
//  SEPeopleModelData.swift
//  Series
//
//  Created by Jesus Cueto on 1/16/22.
//

import Foundation

/**
 Data type that represents a given person from a `JSON` response.
 */
struct SEPeopleModelData: Codable {
    /// Identificaton associated to the person.
    let id: Int
    /// Constant that represents name of the person.
    let name: String
    /// Constant that indicates the gender of a person.
    let gender: String
    /// Constant that indicates the birthday of a person.
    let birthday: String?
    /// Data structure that contains the show's main image as URL.
    let poster: SEShowPosterModel?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case gender
        case birthday
        case poster = "image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: CodingKeys.id)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.gender = try container.decode(String?.self, forKey: CodingKeys.gender) ?? SEKeys.MessageKeys.emptyText
        self.birthday = try container.decode(String?.self, forKey: CodingKeys.birthday) ?? SEKeys.MessageKeys.emptyText
        self.poster = try container.decode(SEShowPosterModel?.self, forKey: CodingKeys.poster) ?? nil
    }
}

/**
 Data type that represents a given show from a search response.
 */
struct SEPeopleSearchDetailModel: Codable {
    /// Person's object
    let person: SEPeopleModelData
    
    private enum CodingKeys: String, CodingKey {
        case person
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.person = try container.decode(SEPeopleModelData.self, forKey: CodingKeys.person)
    }
}
