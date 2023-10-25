//
//  ProfilePresenterFake.swift
//  ImageFeedTests
//
//  Created by Bogdan Fartdinov on 25.10.2023.
//

import Foundation
import ImageFeed

class ProfilePresenterFake: ProfilePresenterProtocol {
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    // 'Profile' initializer is inaccessible due to 'internal' protection level
//    var profile = Profile(username: "test", firstName: "test", lastName: "test", bio: "test")
    
    func viewDidLoad() {
//        didUpdateProfile(with: profile) 
        didUpdateAvatar()
    }

    func didUpdateProfile(with profile: Profile) {
        view?.updateProfile(with: profile)
    }

    func didUpdateAvatar() {
        let avatarURL = "ProfileImageService.shared.avatarURL"
        let url = URL(string: avatarURL)
        view?.updateAvatar(with: url!)
    }
    
    
}
