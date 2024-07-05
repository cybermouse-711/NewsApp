//
//  ContentViewSources.swift
//  NewsApp
//
//  Created by Elizaveta Medvedeva on 03.07.24.
//

import SwiftUI

struct ContentViewSources: View {
    @ObservedObject var sourcesViewModelError = SourcesViewModelError()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchView(searchTerm: self.$sourcesViewModelError.searchString)
                Picker("", selection: self.$sourcesViewModelError.country){
                    Text("us").tag("us")
                    Text("gb").tag("gb")
                    Text("ca").tag("ca")
                    Text("ru").tag("ru")
                    Text("fr").tag("fr")
                    Text("de").tag("de")
                    Text("it").tag("it")
                    Text("in").tag("in")
                    Text("sa").tag("sa")
                }
                .font(.headline)
                .pickerStyle(SegmentedPickerStyle())
                
                SourcesList(sources: sourcesViewModelError.sources)
            }
        }
        .alert(item: self.$sourcesViewModelError.sourcesError) { error in
            Alert(
                title: Text("Network error"),
                message: Text(error.localizedDescription).font(.subheadline),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ContentViewSources_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewSources()
    }
}
