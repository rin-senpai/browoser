//
//  ContentView.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 31/3/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var favourites = Favourites()
    @StateObject var recents = Recents()

    var body: some View {
        NavigationStack {
            List {
                FavouritesList()
            }
            
            .navigationTitle("Browoser")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass").foregroundStyle(.tint)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink(destination: FavouriteView()) {
                        Text("Add")
                            .padding()
                            .foregroundStyle(.tint)
                    }
                }
                
            }
        }
        .environmentObject(favourites)
        .environmentObject(recents)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
