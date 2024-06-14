//
//  NewsAPI.swift
//  NewsApp
//
//  Created by Elizaveta Medvedeva on 07.06.24.
//

import Foundation
import Combine

struct APIConstants {
    static let apiKey: String = "d0a4da41d67d421bab953fc058131407"
    
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dataFormatter)
        return jsonDecoder
    }()
    
    static let formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

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
    
    var absoluteURL: URL? {
        
    }
}

final class NewsAPI {
    
    func fetchArticles(from endpoint: Endpoint) -> AnyPublisher<[Article], Never> {
        guard let url = endpoint.absoluteURL else {
            return Just([Article]()).eraseToAnyPublisher()
        }
        return
        URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .decode(type: NewsResponse.self, decoder: TopLevelDecoder)
            .map{$0.articles}
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func fetchSources(for country: String) -> AnyPublisher<[Source], Never> {
        
    }
}

