//
//  ProfileViewControllerSpy.swift
//  ImageFeed_UnitTests
//
//  Created by Nikita Tsomuk on 29/12/2023.
//

import UIKit.UILabel
import ImageFeed



final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
  var presenter: ImageFeed.ProfilePresenterProtocol?

  var viewDidUpdateAvatar = false
  var viewDidLoadProfile = false

  var userNameLabel = UILabel()
  var loginLabel = UILabel()
  var descriptionLabel = UILabel()

  func updateAvatar(url: URL) {
    viewDidUpdateAvatar = true
  }

  func loadProfile(_ profile: ImageFeed.Profile?) {
    viewDidLoadProfile = true
    if let profile {
        userNameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
  }
}
