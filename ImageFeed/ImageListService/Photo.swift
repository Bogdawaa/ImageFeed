//
//  Photo.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 27.09.2023.
//

import Foundation

struct Photo {
    
    var createdAt: Date? {
        guard let createdAtString = createdAtString  else { return nil }
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: createdAtString)
        return date
    }
    
    let id: String
    let size: CGSize
    let createdAtString: String?
    let welcomeDescription: String?
    let thumbimageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
