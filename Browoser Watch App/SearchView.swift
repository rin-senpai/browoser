//
//  SearchView.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 12/8/2023.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText: String = ""
    
    @Query(sort: \Recent.created, order: .reverse) var recents: [Recent]
    
    func search(text: String) {
        if(text.isValidUrl()) {
            openWebsite(url: text)
        } else if(text != "") {
            openWebsite(url: "google.com/search?q=\(text.replacingOccurrences(of: " ", with: "+"))")
        }
    }
    
    var body: some View {
        ScrollView {
            TextField(
                "",
                text: $searchText
            )
            .tint(.pink)
            .frame(height: 48)
            .clipShape(RoundedRectangle(cornerRadius: .infinity))
            .padding(.vertical)
            .submitLabel(.search)
            .overlay(alignment: .leading) {
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.pink)
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
                let newRecent = Recent(query: $searchText.wrappedValue)
                modelContext.insert(newRecent)
                $searchText.wrappedValue = ""
            }
            
            if (!recents.isEmpty) {
                Section {
                    ForEach(recents) { recent in
                        Button {
                            search(text: recent.query)
                            recent.created = Date()
                        } label: {
                            Text(recent.query)
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
                .navigationTitle {
                    Text("Search").foregroundStyle(.pink)
                }
                .containerBackground(Color("AccentColor").opacity(0.4).gradient, for: .navigation)
                Button {
                    do {
                        try modelContext.delete(model: Recent.self)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                    dismiss()
                } label: {
                    Text("Clear")
                        .foregroundStyle(.pink)
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

#Preview {
    SearchView()
        .modelContainer(for: Recent.self)
}
