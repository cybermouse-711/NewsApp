//
//  ImageLoader.swift
//  NewsApp
//
//  Created by Elizaveta Medvedeva on 20.06.24.
//

import UIKit
import Combine

final class ImageLoaderCache: ObservableObject {
    static let shared = ImageLoaderCache()
    
    private var loaders: NSCache<NSString, ImageLoader> = NSCache()
    
    func loaderFor(article: Article) -> ImageLoader {
        let key = NSString(string: "\(article.title)")
        
        if let loader = loaders.object(forKey: key) {
            return loader
        } else {
            let url = (article.urlToImage != nil && article.urlToImage != "null")
            ? URL(string: article.urlToImage!)
            : nil
            let loader = ImageLoader(url: url)
            loaders.setObject(loader, forKey: key)
            return loader
        }
    }
}

final class ImageLoader: ObservableObject {
    @Published var url: URL?
    @Published var image: UIImage?
    @Published var noData = false
    
    init(url: URL?) {
        self.url = url
        $url
        .setFailureType(to: Error.self)
        .flatMap { (url) -> AnyPublisher<UIImage?, Error> in
                self.fetchImageErr(for: url).eraseToAnyPublisher()
        }
        .sink(receiveCompletion:  {[unowned self] (completion) in
            if case .failure(_) = completion {
                self.noData = true
            }},
              receiveValue: { [unowned self] in
                self.image = $0
        })
        .store(in: &self.cancellableSet)
    }
    
    private func fetchImageErr(for url: URL?) -> AnyPublisher<UIImage?, Error>{
        Future<UIImage?, Error> { [unowned self] promise in
    
            guard let url = url, !self.noData  else {           // 0
                return promise(
                    .failure(URLError(.unsupportedURL)))
            }
            URLSession.shared.dataTaskPublisher(for: url)      // 1
                .tryMap { (data, response) -> Data in          // 2
                    guard let httpResponse = response as? HTTPURLResponse,
                        200...299 ~= httpResponse.statusCode else {
                            throw URLError(.unsupportedURL)
                    }
                    return data
            }
                .map { UIImage(data: $0) }                     // 3
                .receive(on: RunLoop.main)                     // 4
                .sink(
                    receiveCompletion: { (completion) in       // 5
                        if case let .failure(error) = completion {
                            promise(.failure(error))
                        }
                },
                    receiveValue: { promise(.success($0)) })    // 6
                .store(in: &self.cancellableSet)                // 7
        }
            .eraseToAnyPublisher()                              // 8
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
}
