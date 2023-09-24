//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 19.09.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}
