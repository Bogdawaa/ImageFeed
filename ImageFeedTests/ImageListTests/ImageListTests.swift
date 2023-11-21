//
//  ImageListTests.swift
//  ImageFeedTests
//
//  Created by Bogdan Fartdinov on 14.11.2023.
//

@testable import ImageFeed
import XCTest

final class ImageListTests: XCTestCase {
    
    func testDidLoad() {
        //given
        let vc = ImagesListViewController()
        let presenter = ImageListPresenterSpy()
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        _ = vc.view
        
        //then
        XCTAssertTrue(presenter.didLoadCalled)
    }
    
    func testFetchPhotos() {
        //given
        let vc = ImagesListViewController()
        let presenter = ImageListPresenterSpy()
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        presenter.fetchPhotosNextPage()
        
        //then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
    
    func testPresenterCallsPresentPhotos() {
        //given
        let vc = ImageListViewControllerSpy()
        let presenter = ImageListPresenter()
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        presenter.presentPhotos()
        
        //then
        XCTAssertTrue(vc.presentPhotosCalled)
    }
    
    func testSetPhoto() {
        //given
        let vc = ImagesListViewController()
        let presenter = ImageListPresenterSpy()
        let photo = Photo(
            id: "1",
            size: CGSize(width: 10, height: 10),
            createdAt: Date(),
            welcomeDescription: "welcome",
            thumbimageURL: "thumb",
            largeImageURL: "large",
            isLiked: true)
        
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        presenter.setPhoto(photo: photo)
        
        //then
        XCTAssertTrue(presenter.setPhotoCalled)
        XCTAssertEqual(presenter.photo?.id, photo.id)
    }
    
    func testSetIndex() {
        //given
        let vc = ImagesListViewController()
        let presenter = ImageListPresenterSpy()
        let indexPath = IndexPath(row: 0, section: 0)
        
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        presenter.setIndex(indexPath: indexPath)
        
        //then
        XCTAssertTrue(presenter.setIndexPathCalled)
        XCTAssertEqual(presenter.indexPath, indexPath)
    }
    
    func testPhotosInStorageCount() {
        //given
        let vc = ImagesListViewController()
        let presenter = ImageListPresenterSpy()
        let counter: Int = 1
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        let result = presenter.photosInStorageCount
        
        //then
        XCTAssertTrue(presenter.photosInStorageCountCalled)
        XCTAssertEqual(result, counter)
    }
    
    func testUpdateTableViewAnimated() {
        //given
        let vc = ImageListViewControllerSpy()
        let presenter = ImageListPresenter()
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        vc.updateTableViewAnimated(indexes: 0..<10)
        
        //then
        XCTAssertTrue(vc.updateTableViewAnimatedtCalled)
    }
    
    func testReloadRow() {
        //given
        let vc = ImageListViewControllerSpy()
        let presenter = ImageListPresenter()
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        vc.updateRow(indexPath: IndexPath())
        
        //then
        XCTAssertTrue(vc.updateRowCalled)
    }
    
    func testShowAlert() {
        //given
        let vc = ImageListViewControllerSpy()
        let presenter = ImageListPresenter()
        vc.presenter = presenter
        presenter.view = vc
        
        let model = AlertModel(title: "title", message: "message", buttonText: "ok", completion: { return })
        
        //when
        vc.showAlert(alertModel: model)
        
        //then
        XCTAssertTrue(vc.showAlertCalled)
    }
}
