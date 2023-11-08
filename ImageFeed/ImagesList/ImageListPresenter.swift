//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 26.10.2023.
//

import Foundation
import UIKit

protocol ImageListPresenterDelegate: AnyObject {
    func presentPhotos(photos: [Photo])
    func updateRow(indexPath: IndexPath)
    func showAlert(alertModel: AlertModel)
    func fetchPhotosNextPage()
//    func didImageListCellTapLike(indexPath: IndexPath, cell: ImagesListCell, photo: Photo)
}

class ImageListPresenter {
    
    // MARK: public
    weak var presenterDelegate: ImageListPresenterDelegate?
    
    // MARK: private
    private let imageListService = ImageListService.shared
    private var photos: [Photo] = []
    
    // MARK: public methods
    public func setDelegate(delegate: ImageListPresenterDelegate) {
        self.presenterDelegate = delegate
    }
    
    public func fetchPhotosNextPage() {
        imageListService.fetchPhotosNextPage()
    }
    
    public func presentPhotos() {
        self.presenterDelegate?.presentPhotos(photos: imageListService.photos)
    }
    
    public func didImageListCellTapLike(indexPath: IndexPath, cell: ImagesListCell, photo: Photo) {
        UIBlockingProgressHUD.show()
        imageListService.changeLike(
            photoId: photo.id,
            isLike: !photo.isLiked) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    UIBlockingProgressHUD.dismiss()
                    photos = imageListService.photos
                    presenterDelegate?.presentPhotos(photos: photos)
                    cell.setIsLike(photo.isLiked)
                    presenterDelegate?.updateRow(indexPath: indexPath)
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    let alertModel = AlertModel(
                        title: "Ошибка",
                        message: "Возникла ошибка: \(error.localizedDescription)",
                        buttonText: "Ok") { return }
                    presenterDelegate?.showAlert(alertModel: alertModel)
                    break
                }
            }
    }
}
