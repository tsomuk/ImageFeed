//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 30.08.2023.
//

import Foundation
import SwiftKeychainWrapper

// MARK: - Protocol

protocol TokenStorage {
  var token: String? { get }
}

final class OAuth2TokenStorage {

  static let shared = OAuth2TokenStorage()

  private let keychainWrapper = KeychainWrapper.standard
}

// MARK: - TokenStorage

extension OAuth2TokenStorage: TokenStorage {

  var token: String? {
    get {
      keychainWrapper.string(forKey: Constants.bearerToken)
    }
    set {
      guard let newValue else { return }
      keychainWrapper.set(newValue, forKey: Constants.bearerToken)
    }
  }
}

extension OAuth2TokenStorage {

  func removeToken() -> Bool {
    keychainWrapper.removeObject(forKey: Constants.bearerToken)
  }
}
