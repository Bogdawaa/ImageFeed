//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Bogdan Fartdinov on 25.10.2023.
//

import Foundation
import ImageFeed

class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var updateAvatarCalled = false
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func updateProfile(with profile: ImageFeed.Profile) {
        //
    }
}
