//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 06.09.2023.
//

import UIKit
import ProgressHUD
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    
    private let identifier = "ShowAuthViewController"
    private let storage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private lazy var logoImageView: UIImageView = {
        let image = UIImage(named: "practikum")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        view.addSubview(logoImageView)
        
        applyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if storage.token != nil{
            fetchProfile(token: storage.token!)
        }  else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let authViewController = storyBoard.instantiateViewController(
                withIdentifier: "AuthViewController") as? AuthViewController else { return }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
    
    private func applyConstraints() {
        let logoImageViewConstraints = [
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(logoImageViewConstraints)
    }
    
    private func showTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarController")
        window.rootViewController = tabBarController
    }
    
    private func showErrorAlert(handler: @escaping (UIAlertAction)-> Void) {
        let alert = UIAlertController(
            title: "Что -то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code: code)
        }
    }
    
    func fetchOAuthToken(code: String) {
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                UIBlockingProgressHUD.dismiss()
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showErrorAlert { [weak self] _ in
                    guard let self = self else { return }
                    self.fetchOAuthToken(code: code)
                }
                break
            }
        }
    }
    
    func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                UIBlockingProgressHUD.dismiss()
                self.fetchProfileImageURL(username: profile.username)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showErrorAlert { [weak self] _ in
                    guard let self = self else { return }
                    self.fetchProfile(token: token)
                }
                break
            }
        }
    }
    
    func fetchProfileImageURL(username: String) {
        profileImageService.fetchProfileImageURL(username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.showTabBarController()
            case .failure:
                showErrorAlert { [weak self] _ in
                    guard let self = self else { return }
                    self.fetchProfileImageURL(username: username)
                }
                break
            }
        }

    }
}
