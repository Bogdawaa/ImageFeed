//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Bogdan Fartdinov on 24.10.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        _ = vc.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateProfile() {
        //given
        let vc = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()

        vc.presenter = presenter
        presenter.view = vc

        //when
        presenter.viewDidLoad()

        //then
        XCTAssertTrue(vc.updateProfileCalled)
    }
}
