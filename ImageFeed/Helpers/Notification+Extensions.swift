//
//  Notification+Extensions.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 29/11/2023.
//

import Foundation


extension Notification {

  static let userInfoImageURLKey: String = "URL"

  var userInfoImageURL: String? {
    userInfo?[Notification.userInfoImageURLKey] as? String
  }
}
