//
//  Constants.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 02.09.2023.
//

import Foundation

let standardAccessKey = "bU6xdWtAAu8oSb841onJCpjs_TPNmLt5utsGsdcsnqk"
let standardSecretKey = "fi73YsNGnm8dDNdJQjIf7auLglXJTewEm6tFWG-blxk"
let standardRedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let standardAccessScope = "public+read_user+write_likes"

let standardUnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
let standardDefaultBaseURL = URL(string: "https://api.unsplash.com")!

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
           self.accessKey = accessKey
           self.secretKey = secretKey
           self.redirectURI = redirectURI
           self.accessScope = accessScope
           self.defaultBaseURL = defaultBaseURL
           self.authURLString = authURLString
       }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: standardAccessKey,
            secretKey: standardSecretKey,
            redirectURI: standardRedirectURI,
            accessScope: standardAccessScope,
            authURLString: standardUnsplashAuthorizeURLString,
            defaultBaseURL: standardDefaultBaseURL
        )
    }
}

