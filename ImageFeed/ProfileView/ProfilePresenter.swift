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
}

class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?


    func viewDidLoad() {
        didUpdateProfile()
        subscribeUpdateAvatar()
    }
    
    private func didUpdateProfile() {
        guard let profile = profileService.profile else { return }
        view?.updateProfile(with: profile)
    }
    
    private func subscribeUpdateAvatar() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                guard let avatarURL = ProfileImageService.shared.avatarURL,
                      let url = URL(string: avatarURL) else { return }
                view?.updateAvatar(url: url)
            }
    }
}
