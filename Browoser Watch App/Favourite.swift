//
//  Favourite.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 1/4/2023.
//

import Foundation
import SwiftUI

class Favourites: ObservableObject {
    private var websites: Set<Website>
    let defaults = UserDefaults.standard
    
    init() {
        let decoder = JSONDecoder()
        if let data = defaults.data(forKey: "Favourites") {
                    let websiteData = try? decoder.decode(Set<Website>.self, from: data)
                    self.websites = websiteData ?? []
        } else {
            self.websites = [Website(name: "Google", url: "google.com")]
        }
    }
    
    func getWebsites() -> Set<Website> {
        return self.websites
    }
    
    func isEmpty() -> Bool {
        websites.count < 1
    }
    
    func contains(_ website: Website) -> Bool {
        websites.contains(website)
    }
    
    func add(_ website: Website) {
        objectWillChange.send()
        websites.insert(website)
        save()
    }
    
    func remove(_ website: Website) {
        objectWillChange.send()
        websites.remove(website)
        save()
    }
    
    func edit(_ old_website: Website, _ new_website: Website) {
        objectWillChange.send()
        websites.remove(old_website)
        websites.insert(new_website)
        save()
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(websites) {
            defaults.set(encoded, forKey: "Favourites")
        }
    }
}
