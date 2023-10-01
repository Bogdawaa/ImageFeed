//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 27.09.2023.
//

import Foundation

final class ImageListService {
    
    private (set) var photos: [Photo] = []
    
    static let shared = ImageListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImageListProviderDidChange")
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
    func fetchPhotosNextPage(completion: @escaping(Result<[PhotoResult], Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        else {
            let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
            let request = URLRequest.makeHttpRequest(
                path: "/photos"
                + "?page=\(nextPage)",
                httpMethod: "GET")
            let task = object(for: request) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    for item in body {
                        let photo = Photo(
                            id: item.id,
                            size: CGSize(width: item.width, height: item.height),
                            createdAt: DateFormatter().date(from: item.createdAt ?? ""),
                            welcomeDescription: item.description ?? "",
                            thumbimageURL: item.urls.thumb,
                            largeImageURL: item.urls.full,
                            isLiked: item.likedByUser
                        )
                        photos.append(photo)
                    }
                    self.task = nil
                    completion(.success(body))
                    
                    NotificationCenter.default.post(
                        name: ImageListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": photos])
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            self.task = task
            task.resume()
        }
    }
}

extension ImageListService {
    private func object(
        for request: URLRequest,
        completion: @escaping(Result<[PhotoResult], Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<[PhotoResult], Error> in
                Result {
                    try decoder.decode([PhotoResult].self, from: data)
                }
            }
            completion(response)
        }
    }
}
