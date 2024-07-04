//
//  SourcesList.swift
//  NewsApp
//
//  Created by Elizaveta Medvedeva on 03.07.24.
//

import SwiftUI

struct SourcesList: View {
    var sources: [Source]
    
    var body: some View {
        List {
            ForEach(sources) { source in
                NavigationLink  {
                    DetailSourceView(
                        articlesViewModel: ArticlesViewModel(index: 3, text: source.id!),
                        source: source
                    )
                } label: {
                    VStack(alignment: .leading) {
                        HStack(alignment: .bottom) {
                            if UIImage(named: "\(source.id != nil ? source.id! : "")") != nil {
                                Image(uiImage: UIImage(named: "\(source.id != nil ? source.id! : "")")!)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            
                            Text(source.name != nil ? source.name! : "").font(.title)
                            Text(source.country != nil ? source.country! : "")
                        }
                        Text(source.description != nil ? source.description! : "").lineLimit(3)
                    }
                }
            }
        }
        .navigationBarTitle("Sources")
    }
}

let sampleSource1 = Source(id: "abc-news", name: "ABC News", description: "Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com.", country: "us", category: "general", url: "https://abcnews.go.com")

let sampleSource2 = Source(id: "cnbc", name: "CNBC", description:"Get latest business news on stock markets, financial & earnings on CNBC. View world markets streaming charts & video; check stock tickers and quotes." , country: "us", category: "business", url: "http://www.cnbc.com")

struct SourcesList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        SourcesList(sources: [sampleSource1, sampleSource2 ])
        }
    }
}
