//
//  Website.swift
//  Browoser Watch App
//
//  Created by 小鳥遊りん on 1/4/2023.
//

import AuthenticationServices
import Foundation

struct FavIcon {
    enum Size: Int, CaseIterable { case s = 16, m = 32, l = 64, xl = 128, xxl = 256, xxxl = 512 }
    private let domain: String
    init(_ domain: String) { self.domain = domain }
    subscript(_ size: Size) -> String {
        "https://www.google.com/s2/favicons?sz=\(size.rawValue)&domain=\(domain)"
    }
}

func openWebsite(url: String) {
    guard let url = URL(string: "https://\(url)") else {
        return
    }

    let session = ASWebAuthenticationSession(
        url: url,
        callbackURLScheme: nil
    ) { _, _ in

    }

    session.prefersEphemeralWebBrowserSession = true

    session.start()
}
