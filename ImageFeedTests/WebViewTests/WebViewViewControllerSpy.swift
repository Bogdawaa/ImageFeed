//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Bogdan Fartdinov on 22.10.2023.
//

import ImageFeed
import Foundation

class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var loadRequestCalled = false
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        //
    }
    
    func setProgressValue(_ newValue: Float) {
        //
    }
    
    
}
