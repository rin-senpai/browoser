//
//  Extensions.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 1/4/2023.
//

import Foundation

extension String {
    func isValidUrl() -> Bool {
        let regex = "((http|https|ftp)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}
