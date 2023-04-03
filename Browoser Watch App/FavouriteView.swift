//
//  FavouriteView.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 1/4/2023.
//

import SwiftUI

struct FavouriteView: View {
    var prev_name: String = ""
    var prev_url: String = ""
    var current_website: Website?
    var edit: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var favourites: Favourites
    
    @State private var name: String = ""
    @State private var url: String = ""
    
    init(website: Website? = nil) {
        if website != nil {
            _name = State(initialValue: website!.name)
            _url = State(initialValue: website!.url)
            self.current_website = website!
            self.edit = true
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    TextField(
                        "Name",
                        text: $name
                    )
                    
                    TextField(
                        "URL",
                        text: $url
                    )
                    
                    Button {
                        if !($name.wrappedValue == "" || $url.wrappedValue == "") {
                            if edit {
                                favourites.edit(current_website!, Website(name: $name.wrappedValue, url: $url.wrappedValue))
                            } else {
                                favourites.add(Website(name: $name.wrappedValue, url: $url.wrappedValue))
                            }
                        }
                        self.presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Text(edit ? "Save" : "Add")
                            .foregroundColor(.blue)
                    }
                }
                .navigationTitle(edit ? "Edit Favourite" : "Add Favourite")
                .autocorrectionDisabled(true)
            }
        }

    }
}

struct FavouriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteView()
    }
}
