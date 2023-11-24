//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Bogdan Fartdinov on 22.10.2023.
//

import ImageFeed
import Foundation

class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        //
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
    
}
