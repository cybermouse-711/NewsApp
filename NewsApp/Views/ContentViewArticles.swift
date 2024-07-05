//
//  ContentViewArticles.swift
//  NewsApp
//
//  Created by Elizaveta Medvedeva on 04.07.24.
//

import SwiftUI

struct ContentViewArticles: View {
    @ObservedObject var articlesViewModelError = ArticlesViewModelError()
    
    var body: some View {
        VStack {
            Picker("", selection: $articlesViewModelError.indexEndpoint) {
                Text("topHeadLines").tag(0)
                Text("search").tag(1)
                Text("from category").tag(2)
            }.pickerStyle(SegmentedPickerStyle())
            if articlesViewModelError.indexEndpoint == 1 {
                SearchView(searchTerm: $articlesViewModelError.searchString)
            }
            if articlesViewModelError.indexEndpoint == 2 {
                Picker("", selection: $articlesViewModelError.searchString) {
                    Text("sports").tag("sports")
                    Text("health").tag("health")
                    Text("science").tag("science")
                    Text("business").tag("business")
                    Text("technology").tag("technology")
                }
                .onAppear(perform: {
                    self.articlesViewModelError.searchString = "science"
                }).pickerStyle(SegmentedPickerStyle())
            }
            ArticlesList(articles: articlesViewModelError.articles)
        }
        .alert(item: self.$articlesViewModelError.articlesError) { error in
            Alert(
                title: Text("Network Error"),
                message: Text(error.localizedDescription).font(.subheadline),
                dismissButton: .default(Text("OK")))
        }
    }
}

struct ContentViewArticles_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewArticles()
    }
}
