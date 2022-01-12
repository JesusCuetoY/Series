//
//  NetworkConfiguration.swift
//  Series
//
//  Created by Jesus Cueto on 1/12/22.
//

import Foundation

internal enum Environment: String {
    case Development
    case Production
    case UAT
}

internal extension Environment {
    var configuration: Configuration.Type {
        switch self {
        case .Development: return DevelopConfig.self
        case .UAT: return  UATConfig.self
        case .Production: return ProductionConfig.self
        }
    }
}

internal protocol Configuration {
   static var serverURL: String { get }
}

struct ProductionConfig: Configuration {
   static let serverURL = "http://192.168.1.7:3000"
}

struct DevelopConfig: Configuration {
   static let serverURL = "http://192.168.1.7:3000"
}

struct UATConfig: Configuration {
   static let serverURL   = "http://192.168.1.7:3000"
}
