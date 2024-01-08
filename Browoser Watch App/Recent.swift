//
//  Recent.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 12/8/2023.
//

import Foundation
import SwiftData

@Model public class Recent {
    public var query: String
    public var created: Date
    
    public init(query: String, date: Date = Date()) {
        self.query = query
        self.created = date
    }
}
