//
//  SourcesViewModelError.swift
//  NewsApp
//
//  Created by Elizaveta Medvedeva on 04.07.24.
//

import Foundation
import Combine

final class SourcesViewModelError: ObservableObject {
    
    @Published var searchString = ""
    @Published var country = "us"
    @Published var sources = [Source]()
    @Published var sourcesError: NewsError?
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var newsAPI = NewsAPI.shared
    
    private var validString: AnyPublisher<String, Never> {
        $searchString
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    init() {
        Publishers.CombineLatest($country, validString)
            .setFailureType(to: NewsError.self)
            .flatMap { (country, search) -> AnyPublisher<[Source], NewsError> in
                return self.newsAPI.fetchSourcesError(for: country)
                    .map { search == "" ? $0 : $0.filter {
                        ($0.name?.lowercased().contains(search.lowercased()))!
                    } }
                    .eraseToAnyPublisher()
            }
            .sink(
                receiveCompletion:  {[unowned self] (completion) in
                if case let .failure(error) = completion {
                    self.sourcesError = error
                }},
                  receiveValue: { [unowned self] in
                    self.sources = $0
            })
            .store(in: &self.cancellableSet)
    }
}
