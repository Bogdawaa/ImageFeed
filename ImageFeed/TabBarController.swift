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
        
        let imageListViewController = ImagesListViewController()
        let imageListPresenter = ImageListPresenter()
        imageListViewController.presenter = imageListPresenter
        imageListPresenter.view = imageListViewController
        
        imageListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image:  UIImage(named: "tab_editorial_active"),
            selectedImage: nil)
        
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
