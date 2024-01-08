//
//  BrowoserApp.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 31/3/2023.
//

import SwiftUI
import SwiftData

@main
struct BrowoserApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(appContainer)
        }
    }
}

@MainActor
let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Favourite.self, Recent.self)
        
        // Make sure the persistent store is empty. If it's not, return the non-empty container.
        var itemFetchDescriptor = FetchDescriptor<Favourite>()
        itemFetchDescriptor.fetchLimit = 1
        
        guard try container.mainContext.fetch(itemFetchDescriptor).count == 0 else { return container }
        
        // This code will only run if the persistent store is empty.
        let favourites = [
            Favourite(name: "Google", url: "google.com")
        ]
        
        for favourite in favourites {
            container.mainContext.insert(favourite)
        }
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
