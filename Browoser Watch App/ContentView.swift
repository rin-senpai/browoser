//
//  ContentView.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 31/3/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var favourites = Favourites()
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                TextField(
                    "",
                    text: $searchText
                )
                .submitLabel(.search)
                .overlay(alignment: .leading) {
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(.blue)
                            .offset(x: 10, y: 0)
                        Text("Search")
                            .padding(.leading, 16)
                            .font(.body)
                            .foregroundColor(.gray.opacity(0.8))
                        
                    }
                    .allowsHitTesting(false)
                }
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .textContentType(.URL)
                .onSubmit {
                    if($searchText.wrappedValue.isValidUrl()) {
                        openWebsite(url: $searchText.wrappedValue)
                    } else if($searchText.wrappedValue != "") {
                        openWebsite(url: "google.com/search?q=\($searchText.wrappedValue.replacingOccurrences(of: " ", with: "+"))")
                    }
                    $searchText.wrappedValue = ""
                }
                Section(header: Text("FAVOURITES")) {
                    FavouritesList()
                }
                
            }
            .navigationTitle("Browoser")
        }
        .environmentObject(favourites)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
