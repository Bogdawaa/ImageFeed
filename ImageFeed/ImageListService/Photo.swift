//
//  Photo.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 27.09.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbimageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
