//
//  FavouritesList.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 1/4/2023.
//

import SwiftUI

struct FavouritesList: View {
    @EnvironmentObject var favourites: Favourites
    
    var body: some View {
        ForEach(favourites.getWebsites().sorted{$0.name < $1.name}) { website in
            WebsiteButton(name: website.name, url: website.url)
                .swipeActions {
                    Button {
                        favourites.remove(website)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.pink)
                    
                    NavigationLink(destination: FavouriteView(website: website)) {
                        Image(systemName: "pencil")
                    }
                }
        }
            
        NavigationLink(destination: FavouriteView()) {
            HStack(spacing: 10) {
                Image(systemName: "heart")
                    .foregroundColor(.pink)
                    .padding(.leading, 4)
                    .opacity(0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .center) {
                Text("Add")
                    .foregroundColor(.blue)
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

struct FavouritesList_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesList()
            .environmentObject(Favourites())
    }
}
