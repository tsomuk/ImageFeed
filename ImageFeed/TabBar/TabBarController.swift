//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 05/12/2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imageListPresenter = ImageListPresenter()
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController")
        guard let imagesListViewController = imagesListViewController as? ImagesListViewController else { return }
        imageListPresenter.view = imagesListViewController
        imagesListViewController.presenter = imageListPresenter
        let profilePresenter = ProfilePresenter()
        let profileViewController = ProfileViewController()
        profilePresenter.view = profileViewController
        profileViewController.presenter = profilePresenter
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
 
    }
}


private extension TabBarController {
  func setupTabBarItem(for viewController: ProfileViewController, image: String) {
    viewController.tabBarItem = UITabBarItem(
      title: nil,
      image: UIImage(named: image),
      selectedImage: nil
    )
  }
}
