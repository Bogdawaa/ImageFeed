//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 26.10.2023.
//

import Foundation
import UIKit

protocol ImageListPresenterProtocol {
    var view: ImageListViewProtocol? { get set }
    var photosInStorageCount: Int { get }
    func didLoad()
    func fetchPhotosNextPage()
    func presentPhotos()
    func setPhoto(photo: Photo)
    func setIndex(indexPath: IndexPath)
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

class ImageListPresenter: ImageListPresenterProtocol {
    
    // MARK: - public
    weak var view: ImageListViewProtocol?
    
    var photosInStorageCount: Int {
        return imageListService.photos.count
    }
    
    // MARK: - private
    private let imageListService = ImageListService.shared
    private var imageListServiceObserver: NSObjectProtocol?

    private var photos: [Photo]
    
    private var indexPath: IndexPath?
    private var photo: Photo?
    
    // MARK: - init
    init(photos: [Photo] = ImageListService.shared.getPhotos()) {
        self.photos = photos
    }
    
    // MARK: - public methods
    
    public func didLoad() {
        updateTableSubcription()
        imageListService.fetchPhotosNextPage()
        view?.presentPhotos(photos: imageListService.getPhotos())
    }
    
    public func fetchPhotosNextPage() {
        imageListService.fetchPhotosNextPage()
    }
    
    public func presentPhotos() {
        view?.presentPhotos(photos: imageListService.getPhotos())
    }
    
    public func imageListCellDidTapLike(_ cell: ImagesListCell) {
        UIBlockingProgressHUD.show()
        
        guard let indexPath = indexPath else { return }
        guard let photo = photo else { return }
        
        imageListService.changeLike(
            photoId: photo.id,
            isLike: !photo.isLiked) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    UIBlockingProgressHUD.dismiss()
                    photos = imageListService.photos
                    view?.presentPhotos(photos: photos)
                    cell.setIsLike(photo.isLiked)
                    view?.updateRow(indexPath: indexPath)
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    let alertModel = AlertModel(
                        title: "Ошибка",
                        message: "Возникла ошибка: \(error.localizedDescription)",
                        buttonText: "Ok") { return }
                    view?.showAlert(alertModel: alertModel)
                    break
                }
            }
    }
    
    public func setIndex(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    public func setPhoto(photo: Photo) {
        self.photo = photo
    }

    private func updateTableSubcription() {
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                
                let oldPhotosCount = self.photos.count
                let imageListServicePhotosCount = self.photosInStorageCount
                self.photos = imageListService.getPhotos()
                view?.presentPhotos(photos: photos)
                
                if oldPhotosCount != imageListServicePhotosCount {
                    view?.updateTableViewAnimated(indexes: oldPhotosCount..<imageListServicePhotosCount)
                }
            }
    }
}
