//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 24.10.2023.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateAvatar()
    func didUpdateProfile(with profile: Profile)
}

class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared


    func viewDidLoad() {
        if let profile = profileService.profile {
            didUpdateProfile(with: profile)
        }
        didUpdateAvatar()
    }

    func didUpdateProfile(with profile: Profile) {
        view?.updateProfile(with: profile)
    }

    func didUpdateAvatar() {
        guard let avatarURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: avatarURL)
        else { return }
        view?.updateAvatar(with: url)
    }
}
