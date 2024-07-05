//
//  ArticlesViewModelError.swift
//  NewsApp
//
//  Created by Elizaveta Medvedeva on 05.07.24.
//

import Foundation
import Combine

final class ArticlesViewModelError: ObservableObject {
    var newsAPI = NewsAPI.shared
    
    @Published var indexEndpoint = 0
    @Published var searchString = "sports"
    @Published var articles = [Article]()
    @Published var articlesError: NewsError?
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var validString: AnyPublisher<String, Never> {
        $searchString
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    init(index: Int = 0, text: String = "sports") {
        self.indexEndpoint = index
        self.searchString = text
        Publishers.CombineLatest($indexEndpoint, validString)
            .setFailureType(to: NewsError.self)
            .flatMap { (indexEndpoint, search) -> AnyPublisher<[Article], NewsError> in
                if 3...30 ~= search.count {
                    self.articles = [Article]()
                    return self.newsAPI.fetchArticlesError(
                        from:Endpoint(index: indexEndpoint, text: search)!
                    )
                } else {
                    return Just([Article]())
                        .setFailureType(to: NewsError.self)
                        .eraseToAnyPublisher()
                }
            }
            .sink(
                receiveCompletion: { [unowned self] completion in
                    if case let .failure(error) = completion {
                        self.articlesError = error
                    }
                },
                receiveValue: { [unowned self] in
                    self.articles = $0
                }
            )
            .store(in: &self.cancellableSet)
    }
}

