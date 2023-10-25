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
    var updateProfileCalled = false
//    var updateAvatarCalled = false
    
    func updateProfile(with profile: ImageFeed.Profile) {
        updateProfileCalled = true
    }
    
    func updateAvatar(with url: URL) {
//        updateAvatarCalled = true
    }
    
    
}
