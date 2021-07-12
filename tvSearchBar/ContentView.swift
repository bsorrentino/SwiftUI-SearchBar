//
//  ContentView.swift
//  tvSearchBar
//
//  Created by softphone on 12/07/21.
//

import SwiftUI

struct ContentView: View {
    @State var searchText = ""
    
    let columns = [
        GridItem(.fixed(550)),
        GridItem(.fixed(550)),
        GridItem(.fixed(550)),
    ]
    
    var body: some View {
        NavigationView {
            SearchBar(text: $searchText ) {
                
                ScrollView {
                    LazyVGrid( columns: columns) {
                        ForEach( (1...50)
                                    .map( { "item\($0)" } )
                                    .filter({ $0.starts(with: searchText)}), id: \.self) { item in
                            Button( action: {} ) {
                                Text("\(item)").padding()
                            }.buttonStyle(CardButtonStyle())
                        }
                        
                    }
                }
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
