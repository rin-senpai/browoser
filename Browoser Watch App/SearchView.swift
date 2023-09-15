//
//  SearchView.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 12/8/2023.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var recents: Recents
    @State private var searchText: String = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func search(text: String) {
        if(text.isValidUrl()) {
            openWebsite(url: text)
        } else if(text != "") {
            openWebsite(url: "google.com/search?q=\(text.replacingOccurrences(of: " ", with: "+"))")
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                TextField(
                    "",
                    text: $searchText
                )
                .frame(height: 48)
                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                .padding(.vertical)
                .submitLabel(.search)
                .overlay(alignment: .leading) {
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundStyle(.tint)
                            .offset(x: 16, y: 0)
                        Text("Search")
                            .padding(.leading, 18)
                            .font(.caption)
                            .foregroundStyle(.gray.opacity(0.8))
                        
                    }
                    .allowsHitTesting(false)
                }
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .textContentType(.URL)
                .onSubmit {
                    search(text: $searchText.wrappedValue)
                    recents.add(Search(text: $searchText.wrappedValue, date: Date()))
                    $searchText.wrappedValue = ""
                }
                
                if (!recents.isEmpty()) {
                    Section {
                        ForEach(recents.getSearches().sorted{$0.date > $1.date}) { recent in
                            Button {
                                search(text: recent.text)
                                recents.edit(recent, Search(text: recent.text, date: Date()))
                            } label: {
                                Text(recent.text)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonBorderShape(.roundedRectangle)
                        }
                    } header: {
                        Text("Recents")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                    }
                    .navigationTitle("Search")
                    .containerBackground(Color("AccentColor").opacity(0.4).gradient, for: .navigation)
                    Button {
                        recents.clear()
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Clear")
                            .foregroundStyle(.tint)
                    }
                    .buttonStyle(.bordered)
                } else {
                    Spacer()
                    Text("How empty...")
                        .font(.subheadline)
                        .padding()
                    Image("how empty...")
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(Recents())
    }
}
