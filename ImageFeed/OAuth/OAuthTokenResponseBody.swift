//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 05.09.2023.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
