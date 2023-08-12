//
//  Search.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 12/8/2023.
//

import AuthenticationServices
import Foundation

struct Search: Codable, Hashable, Identifiable {
    var id: String {
        return text
    }
    var text: String
    var date: Date
}
