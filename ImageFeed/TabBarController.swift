//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Bogdan Fartdinov on 24.09.2023.
//

import UIKit

final class TabBarController: UITabBarController{
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(
            withIdentifier: "imageListViewController")
        
        let profileViewController = ProfileViewController()
        
        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
