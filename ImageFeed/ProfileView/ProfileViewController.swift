//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 13.08.2023.
//

import UIKit
import Kingfisher

final class ProfileViewVontroller: UIViewController {
    
    private let token = OAuth2TokenStorage().token
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profile: Profile?
    
    private var animationLayers = Set<CALayer>()
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImage(named: "profilePhoto")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileLoginNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileBioLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.setImage(UIImage(named: "exit"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: Selector(("exitButtonClicked")), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .ypBlack
        
        view.addSubview(profileImageView)
        view.addSubview(profileNameLabel)
        view.addSubview(profileLoginNameLabel)
        view.addSubview(profileBioLabel)
        view.addSubview(exitButton)
        
        applyConstraints()

        if let profile = profileService.profile {
            updateProfile(with: profile)
        }
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard let avatarURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: avatarURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20, backgroundColor: .ypBlack)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder.jpeg"),
            options: [.processor(processor)]
        )
    }
    
    private func applyConstraints() {
        let profileImageViewConstraints = [
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70)
        ]
        let exitButtonConstraints = [
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.widthAnchor.constraint(equalToConstant: 44)
        ]
        let profileNameConstraints = [
            profileNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            profileNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
        ]
        let profileNicknameConstraints = [
            profileLoginNameLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8),
            profileLoginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileLoginNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
        ]
        let profileMessageConstraints = [
            profileBioLabel.topAnchor.constraint(equalTo: profileLoginNameLabel.bottomAnchor, constant: 8),
            profileBioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileBioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(profileImageViewConstraints)
        NSLayoutConstraint.activate(profileNameConstraints)
        NSLayoutConstraint.activate(profileNicknameConstraints)
        NSLayoutConstraint.activate(profileMessageConstraints)
        NSLayoutConstraint.activate(exitButtonConstraints)
    }
    
    private func updateProfile(with profile: Profile) {
        profileNameLabel.text = profile.name
        profileLoginNameLabel.text = profile.loginName
        profileBioLabel.text = profile.bio
    }
    
    @objc private func exitButtonClicked() {
        CookieService.clean()
        OAuth2TokenStorage().cleanToken()
        
        let vc = SplashViewController()
        self.show(vc, sender: self)
    }
}
