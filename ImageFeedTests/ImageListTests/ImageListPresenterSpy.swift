//
//  ImageListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Bogdan Fartdinov on 14.11.2023.
//

import Foundation
@testable import ImageFeed

class ImageListPresenterSpy: ImageListPresenterProtocol {
    var view: ImageFeed.ImageListViewProtocol?
    var didLoadCalled: Bool = false
    var fetchPhotosNextPageCalled: Bool = false
    var presentPhotosCalled: Bool = false
    var photosInStorageCountCalled: Bool = false
    var setPhotoCalled: Bool = false
    var setIndexPathCalled: Bool = false

    var photosInStorageCount: Int {
        photosInStorageCountCalled = true
        return 1
    }
    
    var photo: Photo?
    var indexPath: IndexPath?
    
    func didLoad() {
        didLoadCalled = true
    }
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func presentPhotos() {
        presentPhotosCalled = true
    }
    
    func setPhoto(photo: ImageFeed.Photo) {
        setPhotoCalled = true
        self.photo = photo
    }
    
    func setIndex(indexPath: IndexPath) {
        setIndexPathCalled = true
        self.indexPath = indexPath
    }
    
    func imageListCellDidTapLike(_ cell: ImageFeed.ImagesListCell) {
        //
    }
}
