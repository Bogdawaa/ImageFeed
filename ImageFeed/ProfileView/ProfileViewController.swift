//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 13.08.2023.
//

import UIKit

final class ProfileViewVontroller: UIViewController {
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImage(named: "profilePhoto")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var profileName: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileNickname: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileMessage: UILabel = {
        let label = UILabel()
        label.text = "Hello"
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
        return btn
    }()
    
    override func viewDidLoad() {
        view.addSubview(profileImageView)
        view.addSubview(profileName)
        view.addSubview(profileNickname)
        view.addSubview(profileMessage)
        view.addSubview(exitButton)
        
        applyConstraints()
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
            profileName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            profileName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
        ]
        let profileNicknameConstraints = [
            profileNickname.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8),
            profileNickname.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileNickname.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
        ]
        let profileMessageConstraints = [
            profileMessage.topAnchor.constraint(equalTo: profileNickname.bottomAnchor, constant: 8),
            profileMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(profileImageViewConstraints)
        NSLayoutConstraint.activate(profileNameConstraints)
        NSLayoutConstraint.activate(profileNicknameConstraints)
        NSLayoutConstraint.activate(profileMessageConstraints)
        NSLayoutConstraint.activate(exitButtonConstraints)
    }
}
