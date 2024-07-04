//
//  TabedView.swift
//  NewsApp
//
//  Created by Elizaveta Medvedeva on 04.07.24.
//

import SwiftUI

struct TabedView: View {
    var body: some View {
        TabView {
            ContentViewArticles()
                .tabItem {
                    Image(systemName: "doc.on.doc.fill")
                    Text("Articles")
                }
            
            ContentViewSources()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Sources")
                }
        }
        .accentColor(.blue)
    }
}

struct TabvedView_Previews: PreviewProvider {
    static var previews: some View {
        TabedView()
    }
}
