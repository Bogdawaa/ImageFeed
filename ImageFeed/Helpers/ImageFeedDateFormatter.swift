//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 17.10.2023.
//

import Foundation

class  ImageFeedDateFormatter {
    
    static let shared = ImageFeedDateFormatter()
    
    private init() { }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    func dateString(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func isoDateFromString(from string: String) -> Date? {
        return isoFormatter.date(from: string)
    }
}
