//
//  Favourite.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 1/4/2023.
//

import Foundation
import SwiftData

@Model public class Favourite {
    public var name: String
    public var url: String
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
