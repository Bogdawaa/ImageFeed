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
}

class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared


    func viewDidLoad() {
        didUpdateProfile()
        didUpdateAvatar()
    }

    func didUpdateAvatar() {
        view?.updateAvatar()
    }
    
    private func didUpdateProfile() {
        guard let profile = profileService.profile else { return }
        view?.updateProfile(with: profile)
    }
}
