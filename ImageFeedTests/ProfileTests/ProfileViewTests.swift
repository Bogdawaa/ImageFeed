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
    
    func testUpdateAvatar() {
        //given
        let vc = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        let url = URL(string: "photo.ru")

        vc.presenter = presenter
        presenter.view = vc

        //when
        vc.updateAvatar(url: url!)

        //then
        XCTAssertTrue(vc.updateAvatarCalled)
        XCTAssertEqual(vc.avatarURL, url)
    }
    
    func testUpdateProfile() {
        //given
        let vc = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        let profile = Profile(
            username: "username",
            firstName: "Bogdan",
            lastName: "Fartdinov",
            bio: "bio"
        )

        vc.presenter = presenter
        presenter.view = vc

        //when
        vc.updateProfile(with: profile)

        //then
        XCTAssertTrue(vc.updateProfileCalled)
        XCTAssertEqual(vc.profile.name, profile.name)
    }
}
