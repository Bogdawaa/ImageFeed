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
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}