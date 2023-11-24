//
//  ImageListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Bogdan Fartdinov on 15.11.2023.
//

import Foundation
@testable import ImageFeed

final class ImageListViewControllerSpy: ImageListViewProtocol {

    var presenter: ImageFeed.ImageListPresenterProtocol?
    
    var presentPhotosCalled: Bool = false
    var updateRowCalled: Bool = false
    var showAlertCalled: Bool = false
    var imageListCellDidTapLikeCalled: Bool = false
    var updateTableViewAnimatedtCalled: Bool = false

    func presentPhotos(photos: [ImageFeed.Photo]) {
        presentPhotosCalled = true
    }
    
    func updateRow(indexPath: IndexPath) {
        updateRowCalled = true
    }
    
    func showAlert(alertModel: ImageFeed.AlertModel) {
        showAlertCalled = true
    }
    
    func imageListCellDidTapLike(_ cell: ImageFeed.ImagesListCell) {
        //
    }
 
    func updateTableViewAnimated(indexes: Range<Int>) {
        updateTableViewAnimatedtCalled = true
    }
}
