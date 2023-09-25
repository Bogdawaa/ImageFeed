//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 19.09.2023.
//

import Foundation

struct Img: Codable {
    let small: String
    let medium: String
    let large: String
}

struct UserResult: Codable {
    let profileImage: Img
}

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared

    func fetchProfileImageURL(
        _ username: String,
        _ completion: @escaping (Result<String, Error>) -> Void) {
            assert(Thread.isMainThread)
            guard let token = OAuth2TokenStorage().token else { return }
            var request = URLRequest.makeHttpRequest(path: "/users/\(username)", httpMethod: "GET")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let task = object(for: request) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    avatarURL = body.profileImage.small
                    completion(.success(body.profileImage.small))
                    guard let avatarURL = avatarURL else { return }
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            task.resume()
        }
}

extension ProfileImageService {
    private func object(
        for request: URLRequest,
        completion: @escaping(Result<UserResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResult, Error> in
                Result {
                    try decoder.decode(UserResult.self, from: data)
                }
            }
            completion(response)
        }
    }
}
