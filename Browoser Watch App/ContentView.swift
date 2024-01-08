//
//  ContentView.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 31/3/2023.
//

import SwiftUI

enum SelectedTab {
    case browse
    case chat
}

struct ContentView: View {
    @State var selectedTab: SelectedTab = SelectedTab.browse

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                FavouritesList()
                    .tag(SelectedTab.browse)
                    .navigationTitle {
                        Text("Browse").foregroundStyle(.pink)
                    }
                    .containerBackground(.black, for: .tabView)
                
                ChatView()
                    .tag(SelectedTab.chat)
                    .navigationTitle {
                        Text("Chat").foregroundStyle(.blue)
                    }
                    .containerBackground(.black, for: .tabView)
            }
            .tabViewStyle(.carousel)
            .toolbar {
                if selectedTab == SelectedTab.browse {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink(destination: SearchView()) {
                            Image(systemName: "magnifyingglass").foregroundStyle(.pink)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [
            Favourite.self,
            Recent.self
        ])
}
