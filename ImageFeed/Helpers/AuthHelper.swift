//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 28/12/2023.
//

import Foundation


protocol AuthHelperProtocol {
    
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

final class AuthHelper {
  // MARK: - Public properties

  let configuration: AuthConfiguration

  // MARK: - Init

  init(configuration: AuthConfiguration = .standard) {
    self.configuration = configuration
  }
}

// MARK: - Private properties & methods

extension AuthHelper {
    
  enum WebKeyConstant {
    static let clientId = "client_id"
    static let redirectUri = "redirect_uri"
    static let responseType = "response_type"
    static let scope = "scope"
  }

  func authURL() -> URL {
    guard var urlComponents = URLComponents(string: configuration.authURLString) else {
      preconditionFailure("Incorrect string: \(configuration.authURLString)")
    }
    urlComponents.queryItems = [
      URLQueryItem(name: WebKeyConstant.clientId, value: configuration.accessKey),
      URLQueryItem(name: WebKeyConstant.redirectUri, value: configuration.redirectURI),
      URLQueryItem(name: WebKeyConstant.responseType, value: Constants.code),
      URLQueryItem(name: WebKeyConstant.scope, value: configuration.accessScope)
    ]
    guard let url = urlComponents.url else {
      preconditionFailure("Incorrect URL: \(String(describing: urlComponents.url))")
    }
    return url
  }
}

// MARK: - AuthHelperProtocol

extension AuthHelper: AuthHelperProtocol {
  func authRequest() -> URLRequest {
    URLRequest(url: authURL())
  }

  func code(from url: URL) -> String? {
    if
      let urlComponents = URLComponents(string: url.absoluteString),
      urlComponents.path == Constants.authorizedURLPath,
      let items = urlComponents.queryItems,
      let codeItem = items.first(where: { $0.name == Constants.code }) {
      return codeItem.value
    } else {
      return nil
    }
  }
}
