//
//  NewsAPI.swift
//  NewsApp
//
//  Created by Elizaveta Medvedeva on 07.06.24.
//

import Foundation

enum Endpoint {
    case topHeadLines
    case articlesFromCategory(_ category: String)
    case articlesFromSource(_ source: String)
    case search(searchFilter: String)
    case sources(country: String)
    
    var baseURL: URL? { URL(string: "https://newsapi.org/v2/") ?? nil }
    
    init? (index: Int, text: String = "sports")  {
        switch index {
        case 0:
            self = .topHeadLines
        case 1:
            self = .search(searchFilter: text)
        case 2:
            self = .articlesFromCategory(text)
        case 3:
            self = .articlesFromSource(text)
        case 4:
            self = .sources(country: text)
        default:
            return nil
        }
    }
    
    func path() -> String {
        switch self {
        case .topHeadLines:
            return "top-headlines"
        case .articlesFromCategory(_):
            return "top-headlines"
        case .articlesFromSource(_):
            return "everything"
        case .search(_):
            return "everything"
        case .sources(_):
            return "sources"
        }
    }
}
