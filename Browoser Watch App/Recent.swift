//
//  Recent.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 12/8/2023.
//

import Foundation

class Recents: ObservableObject {
    private var searches: Set<Search>
    let defaults = UserDefaults.standard
    
    init() {
        let decoder = JSONDecoder()
        if let data = defaults.data(forKey: "Recents") {
                    let searchData = try? decoder.decode(Set<Search>.self, from: data)
                    self.searches = searchData ?? []
        } else {
            self.searches = []
        }
    }
    
    func getSearches() -> Set<Search> {
        return self.searches
    }
    
    func isEmpty() -> Bool {
        searches.count < 1
    }
    
    func contains(_ search: Search) -> Bool {
        searches.contains(search)
    }
    
    func add(_ search: Search) {
        objectWillChange.send()
        searches.insert(search)
        save()
    }
    
    func remove(_ search: Search) {
        objectWillChange.send()
        searches.remove(search)
        save()
    }
    
    func edit(_ oldSearch: Search, _ newSearch: Search) {
        objectWillChange.send()
        searches.remove(oldSearch)
        searches.insert(newSearch)
        save()
    }
    
    func clear() {
        searches = []
        save()
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(searches) {
            defaults.set(encoded, forKey: "Recents")
        }
    }
}
