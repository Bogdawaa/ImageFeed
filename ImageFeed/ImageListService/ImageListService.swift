//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 27.09.2023.
//

import Foundation

final class ImageListService {
    
    static let shared = ImageListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImageListProviderDidChange")
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    private let urlSession = URLSession.shared
    
    private init() { }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard let token = OAuth2TokenStorage().token else { return }
        if task != nil { return }
        else {
            let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
            if lastLoadedPage == nil {
                lastLoadedPage = 1
            } else {
                lastLoadedPage = lastLoadedPage! + 1
            }
            var request = URLRequest.makeHttpRequest(
                path: "/photos"
                + "?page=\(nextPage)",
                httpMethod: "GET")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
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
                    
                    NotificationCenter.default.post(
                        name: ImageListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": photos])
                case .failure:
                    break
                }
            }
            self.task = task
            task.resume()
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping(Result<Void, Error>)->Void) {
        assert(Thread.isMainThread)
        let httpMethod = isLike == true ? "POST" : "DELETE"
        guard let token = OAuth2TokenStorage().token else { return }
        var request = URLRequest.makeHttpRequest(
            path: "/photos"
            + "/\(photoId)"
            + "/like",
            httpMethod: httpMethod)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = singleObject(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let newPhoto = Photo(
                        id: body.photo.id,
                        size: CGSize(width: body.photo.width, height: body.photo.height),
                        createdAt: ISO8601DateFormatter().date(from: body.photo.createdAt ?? ""),
                        welcomeDescription: body.photo.description ?? "",
                        thumbimageURL: body.photo.urls.thumb,
                        largeImageURL: body.photo.urls.full,
                        isLiked: body.photo.likedByUser
                    )
                    self.photos[index] = newPhoto
                }
                
                NotificationCenter.default.post(
                    name: ImageListService.didChangeNotification,
                    object: self,
                    userInfo: ["photos": photos])
                completion(.success(()))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        task.resume()
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
    private func singleObject(
        for request: URLRequest,
        completion: @escaping(Result<SinglePhoto, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<SinglePhoto, Error> in
                Result {
                    try decoder.decode(SinglePhoto.self, from: data)
                }
            }
            completion(response)
        }
    }
}
