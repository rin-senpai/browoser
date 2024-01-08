//
//  FavouritesList.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 1/4/2023.
//

import SwiftUI
import SwiftData

struct FavouritesList: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Favourite.name) var favourites: [Favourite]
    
    var body: some View {
        List {
            ForEach(favourites) { favourite in
                WebsiteButton(name: favourite.name, url: favourite.url)
                    .swipeActions {
                        Button {
                            modelContext.delete(favourite)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.pink)
                        
                        NavigationLink(destination: FavouriteView(favourite: favourite)) {
                            Image(systemName: "pencil")
                        }
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                NavigationLink(destination: FavouriteView()) {
                    Text("Add")
                        .padding()
                        .foregroundStyle(.pink)
                }
            }
        }
    }
}

struct WebsiteButton: View {
    var name: String
    var url: String
    
    var body: some View {
        Button {
            openWebsite(url: url)
        } label: {
            HStack(spacing: 10) {
                AsyncImage(
                    url: URL(string: FavIcon(url)[FavIcon.Size.l])
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .padding(.leading, 4)
                .frame(maxWidth: 22, maxHeight: 22)
                Text(name)
                    .padding(.leading, 2)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    FavouritesList()
}
