//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 27.09.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
}
