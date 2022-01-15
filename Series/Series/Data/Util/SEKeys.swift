//
//  SEKeys.swift
//  Series
//
//  Created by Jesus Cueto on 1/12/22.
//

import Foundation

internal struct SEKeys {
    // Cell
    // Database
    // Image Keys
    
    internal struct ApiKeys {
        static let AppEnvironment: Environment = {
            let environmentString = Bundle.main.infoDictionary!["Product environment"] as! String
            guard let environment = Environment(rawValue: environmentString)
                else { fatalError("Invalid Environment: \(environmentString)") }
            return environment
        }()
        
        // MARK: - Series's URLs
        static let showListURL = "shows"
        static let showSearchURL = "search/shows"
        static let showSeasonsURL = "seasons"
        static let showEpisodesURL = "episodes"
    }

    // MARK: - Message keys
    internal struct MessageKeys {
        static let emptyText = ""
        // Database
        static let storageError = "SE_STORAGE_SAVE_ERROR"
        static let storageDeleteError = "SE_STORAGE_DELETE_ERROR"
        static let storageFetchError = "SE_STORAGE_FETCH_ERROR"
        // Network
        static let networkServerError = "SE_SERVER_ERROR"
        static let networkTimeOutError = "SE_TIMEOUT_ERROR"
        static let networkOfflineError = "SE_OFFLINE_ERROR"
        static let networkGeneralError = "SE_GENERAL_ERROR"
        static let networkParserErrorMessage = "SE_PARSER_ERROR_MESSAGE"
        static let networkParserErrorTitle = "SE_PARSER_ERROR_TITLE"
        // Series List
        static let listErrorTitle = "SE_SHOW_LIST_ERROR_TITLE"
        static let listSearchPlaceholder = "SE_SHOW_LIST_SEARCH_PLACEHOLDER"
        static let listSearchEmptyErrorMessage = "SE_SHOW_LIST_SEARCH_EMPTY_MESSAGE"
        // Series Detail
        // Episodes
        // Episodes Detail
        // Person
        // Person Detail
        // Favorite
    }

    // MARK: - UIController's identifiers - Segues
    internal struct Resources {
        internal struct Images {
            // System
            static let plusImage = "plus"
            static let minusImage = "minus"
            static let shareImage = "square.and.arrow.up"
        }
    }
}
