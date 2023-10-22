//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 02.09.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController( _ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let identifier = "showWebView"

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(identifier)")
            }
            let webViewPresenter = WebViewPresenter()
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
}
