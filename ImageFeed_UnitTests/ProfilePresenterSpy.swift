//
//  ProfilePresenterSpy.swift
//  ImageFeed_UnitTests
//
//  Created by Nikita Tsomuk on 29/12/2023.
//

import Foundation
import ImageFeed


final class ProfilePresenterSpy: ProfilePresenterProtocol {
  var view: ProfileViewControllerProtocol?

  var viewDidLoadCalled = false
  var viewDidResetAccount = false

  func viewDidLoad() {
    viewDidLoadCalled = true
  }

  func resetAccount() {
    viewDidResetAccount = true
  }
}
