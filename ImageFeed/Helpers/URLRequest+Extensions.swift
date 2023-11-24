//
//  URLRequest+Extensions.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 05.09.2023.
//

import Foundation

extension URLRequest {
    static func makeHttpRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = AuthConfiguration.standard.defaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}
