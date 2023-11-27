//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 30.08.2023.
//

import Foundation

protocol TokenStorage {
  var token: String? { get }
}

// MARK: - OAuth2TokenStorage

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
  private enum Keys: String {
    case token
  }
  private let userDefaults: UserDefaults

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
}

// MARK: - TokenStorage

extension OAuth2TokenStorage: TokenStorage {
  var token: String? {
    get {
      userDefaults.string(forKey: Keys.token.rawValue)
    }
    set {
      userDefaults.set(newValue, forKey: Keys.token.rawValue)
    }
  }
}
