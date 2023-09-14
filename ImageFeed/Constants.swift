//
//  Constants.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 02.09.2023.
//

import Foundation

struct Constants {
    static let accessKey = "bU6xdWtAAu8oSb841onJCpjs_TPNmLt5utsGsdcsnqk"
    static let secretKey = "fi73YsNGnm8dDNdJQjIf7auLglXJTewEm6tFWG-blxk"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"

    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}

