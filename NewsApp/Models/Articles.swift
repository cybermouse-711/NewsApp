//
//  Articles.swift
//  NewsApp
//
//  Created by Elizaveta Medvedeva on 07.06.24.
//

import Foundation

struct NewsResponse: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
}

struct Article: Decodable, Identifiable {
    var id = UUID()
    let title: String
    let description: String?
    let author: String?
    let urlToImage: String?
    let publishedAt: Date?
    let source: Source
    let url: String?
}

struct SourceResponse: Decodable {
    let status: String
    let sources: [Source]
}

struct Source: Decodable, Identifiable {
    let id: String?
    let name: String?
    let description: String?
    let country: String?
    let category: String?
    let url: String?
}
