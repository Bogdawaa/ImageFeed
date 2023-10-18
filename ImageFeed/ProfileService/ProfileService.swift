//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 17.09.2023.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    
    private (set) var profile: Profile?
    
    private let urlSession = URLSession.shared

    private init() { }
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<ProfileResult, Error>) -> Void) {
            assert(Thread.isMainThread)
            var request = URLRequest.makeHttpRequest(path: "/me", httpMethod: "GET")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = object(for: request) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let profileResult):
                    profile = Profile(
                        username: profileResult.username,
                        firstName: profileResult.firstName,
                        lastName: profileResult.lastName ?? "",
                        bio: profileResult.bio ?? ""
                    )
                    completion(.success(profileResult))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            task.resume()
        }
}

extension ProfileService {
    private func object(
        for request: URLRequest,
        completion: @escaping(Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result {
                    try decoder.decode(ProfileResult.self, from: data)
                }
            }
            completion(response)
        }
    }
}
