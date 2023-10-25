//
//  Profile.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 19.09.2023.
//

import Foundation

public struct Profile {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String
    
    var name: String {
        get {
            return firstName + " " + lastName
        }
    }
    
    var loginName: String {
        get {
            return "@" + username
        }
    }
}
