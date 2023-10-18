//
//  CookieService.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 10.10.2023.
//

import Foundation
import WebKit

class CookieService {
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantFuture)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(
                    ofTypes: record.dataTypes,
                    for: [record],
                    completionHandler: {})
            }
        }
    }
}
