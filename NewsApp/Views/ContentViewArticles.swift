//
//  ContentViewArticles.swift
//  NewsApp
//
//  Created by Elizaveta Medvedeva on 04.07.24.
//

import SwiftUI

struct ContentViewArticles: View {
    @ObservedObject var articlesViewModel = ArticlesViewModel()
    
    var body: some View {
        VStack {
            Picker("", selection: $articlesViewModel.indexEndpoint) {
                Text("topHeadLines").tag(0)
                Text("search").tag(1)
                Text("from category").tag(2)
            }.pickerStyle(SegmentedPickerStyle())
            if articlesViewModel.indexEndpoint == 1 {
                SearchView(searchTerm: $articlesViewModel.searchString)
            }
            if articlesViewModel.indexEndpoint == 2 {
                Picker("", selection: $articlesViewModel.searchString) {
                    Text("sports").tag("sports")
                    Text("health").tag("health")
                    Text("science").tag("science")
                    Text("business").tag("business")
                    Text("technology").tag("technology")
                }
                .onAppear(perform: {
                    self.articlesViewModel.searchString = "science"
                }).pickerStyle(SegmentedPickerStyle())
            }
            ArticlesList(articles: articlesViewModel.articles)
        }
    }
}

struct ContentViewArticles_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewArticles()
    }
}
