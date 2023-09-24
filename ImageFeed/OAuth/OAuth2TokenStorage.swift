//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 05.09.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            return keychainWrapper.string(forKey: "token")
        }
        set {
            if let newValue = newValue {
                keychainWrapper.set(newValue, forKey: "token")

            }
        }
    }
}
