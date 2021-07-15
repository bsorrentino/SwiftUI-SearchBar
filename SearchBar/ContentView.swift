//
//  ContentView.swift
//  SearchBox
//
//  Created by softphone on 09/07/21.
//

import SwiftUI

struct ContentView: View {
    @State var searchText = ""
    var body: some View {
        NavigationView {
            SearchBar(text: $searchText ) {
                List {
                        ForEach( (1...50)
                                    .map( { "Item\($0)" } )
                                    .filter({ $0.starts(with: searchText)}), id: \.self) { item in
                            Text("\(item)")
                        }
                        
                    }
            }.navigationTitle("Search Bar Test")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
