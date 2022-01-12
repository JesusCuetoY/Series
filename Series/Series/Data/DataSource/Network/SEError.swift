//
//  SEError.swift
//  Series
//
//  Created by Jesus Cueto on 1/12/22.
//

import Foundation

struct SEError: Codable {
    var code: Int?
    var message: String?
    var messageDetail: String?
}
