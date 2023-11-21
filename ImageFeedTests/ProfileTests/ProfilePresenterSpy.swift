//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Bogdan Fartdinov on 24.10.2023.
//

import Foundation
import ImageFeed

class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
