//
//  FavouriteView.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 1/4/2023.
//

import SwiftUI
import SwiftData

struct FavouriteView: View {
    var prev_name: String = ""
    var prev_url: String = ""
    var current_favourite: Favourite?
    var edit: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    @State private var url: String = ""
    
    init(favourite: Favourite? = nil) {
        if favourite != nil {
            _name = State(initialValue: favourite!.name)
            _url = State(initialValue: favourite!.url)
            self.current_favourite = favourite!
            self.edit = true
        }
    }
    
    var body: some View {
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
                        save()
                    }
                    dismiss()
                    
                } label: {
                    Text(edit ? "Save" : "Add")
                        
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle {
                Text(edit ? "Edit Favourite" : "Add Favourite").foregroundStyle(.tint)
            }
            .autocorrectionDisabled(true)
        }
        .containerBackground(.pink.opacity(0.4).gradient, for: .navigation)
        .tint(.pink)
    }
    
    private func save() {
        if edit {
            current_favourite?.name = $name.wrappedValue
            current_favourite?.url = $url.wrappedValue
        } else {
            let newFavourite = Favourite(name: $name.wrappedValue, url: $url.wrappedValue)
            modelContext.insert(newFavourite)
        }
    }
}

#Preview {
    FavouriteView()
}
