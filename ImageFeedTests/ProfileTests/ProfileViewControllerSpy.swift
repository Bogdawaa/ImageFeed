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
    var updateProfileCalled = false
    var avatarURL: URL!
    var profile: Profile!
    
    func updateAvatar(url: URL) {
        updateAvatarCalled = true
        self.avatarURL = url
    }
    
    func updateProfile(with profile: ImageFeed.Profile) {
        updateProfileCalled = true
        self.profile = profile
    }
}
