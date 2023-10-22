//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 02.09.2023.
//

import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressHidden(_ isHidden: Bool)
    func setProgressValue(_ newValue: Float)
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    var presenter: WebViewPresenterProtocol?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var webView: WKWebView!
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        estimatedProgressObservation = webView.observe(
//            \.estimatedProgress,
//             changeHandler: { [weak self] _, _ in
//                 guard let self = self else { return }
//                 presenter?.didUpdateProgressValue(webView.estimatedProgress)
//             })
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction) {
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.allow)
            } else {
                decisionHandler(.allow)
            }
    }
}
