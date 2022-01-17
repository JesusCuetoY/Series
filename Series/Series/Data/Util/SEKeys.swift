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
        // MARK: - People's URLs
        static let peopleSearchURL = "search/people"
        static let peopleListURL = "people"
        static let peopleShowsURL = "castcredits"
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
        static let listTitle = "SE_SHOW_LIST_TITLE"
        // Series Detail
        static let showDetailScheduleTitle = "SE_SHOW_DETAIL_SCHEDULE_TITLE"
        static let showDetailGenreTitle = "SE_SHOW_DETAIL_GENRES_TITLE"
        static let emptyInformation = "SE_SHOW_SEASON_EMPTY_LIST"
        // Episodes
        static let emptyImage = "SE_EMPTY_POSTER_TITLE"
        // Episodes Detail
        static let episodeDetailError = "SE_EPISODE_DETAIL_ERROR_TITLE"
        static let episodeDetailSeasonTitle = "SE_EPISODE_DETAIL_SEASON_TITLE"
        static let episodeDetailNumberTitle = "SE_EPISODE_DETAIL_NUMBER_TITLE"
        static let episodeDetailSummaryTitle = "SE_EPISODE_DETAIL_SUMMARY_TITLE"
        // Person
        // Person Detail
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
