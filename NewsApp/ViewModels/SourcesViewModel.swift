//
//  SourcesViewModel.swift
//  NewsApp
//
//  Created by Elizaveta Medvedeva on 03.07.24.
//

import Foundation
import Combine

final class SourcesViewModel: ObservableObject {
    @Published var searchString = ""
    @Published var country = "us"
    @Published var sources = [Source]()
    
    private var validString: AnyPublisher<String, Never> {
        $searchString
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    init() {
        Publishers.CombineLatest($country, validString)
            .flatMap { (country, search) -> AnyPublisher<[Source], Never> in
                NewsAPI.shared.fetchSources(for: country)
                    .map{ search == "" ? $0 : $0.filter {
                        ($0.name?.lowercased().contains(search.lowercased()))!}
                    }
                    .eraseToAnyPublisher()
            }
            .assign(to: \.sources, on: self)
            .store(in: &self.cancellableSet)
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
}
