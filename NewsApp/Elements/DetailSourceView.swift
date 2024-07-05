//
//  DetailSourceView.swift
//  NewsApp
//
//  Created by Elizaveta Medvedeva on 04.07.24.
//

import SwiftUI

struct DetailSourceView: View {
    @ObservedObject var articlesViewModel: ArticlesViewModel
    @State var shouldPresent = false
    @State var sourceURL: URL?
    
    var source: Source
    
    var body: some View {
        VStack {
            HStack {
                Text(source.name != nil ? source.name! : "")
                Spacer()
                Text(source.category != nil ? source.category! : "")
                Text(source.country != nil ? source.country! : "")
            }
            .font(.title)
            
            Text(source.description != nil ? source.description! : "")
            
            Button(
                action: {
                    self.sourceURL = URL(string: self.source.url!)
                    self.shouldPresent = true
                },
                label: {
                    Text(source.url != nil ? source.url! : "").foregroundColor(.blue)
                }
            )
            Spacer()
            ZStack {
                Color.gray
                Text("Articles")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
            .frame(height: 30)
            ArticlesList(articles: articlesViewModel.articles)
        }
        .sheet(isPresented: $shouldPresent) {
            SafariView(url: self.sourceURL!)
        }
        .padding(10)
        .navigationBarTitle(Text(source.id!))
    }
}

struct DetailSourceView_Previews: PreviewProvider {
    static var previews: some View {
        DetailSourceView(articlesViewModel:  ArticlesViewModel(index: 3, text: "abc-news"), source: sampleSource1)
    }
}
