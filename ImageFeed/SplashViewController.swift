//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 06.09.2023.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let identifier = "ShowAuthViewController"
    private let storage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            showTabBarController()
        } else {
            performSegue(withIdentifier: identifier, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                fatalError("Failet to load \(identifier)")
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func showTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Error in window configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code: code)
            self.storage.token = code
        }
    }
    func fetchOAuthToken(code: String) {
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.storage.token = code
                self.showTabBarController()
            case .failure:
                break
            }
        }
    }
}
