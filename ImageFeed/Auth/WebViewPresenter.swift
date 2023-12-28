//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 28/12/2023.
//

import Foundation


 protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func  viewDidLoad()
    func didUpdateProgressValue( _ newValue: Double)
    func code(from url: URL) -> String?
}

enum WebKeyConstant {
  static let clientId = "client_id"
  static let redirectUri = "redirect_uri"
  static let responseType = "response_type"
  static let scope = "scope"
}

// MARK: - Class

 final class WebViewPresenter: WebViewPresenterProtocol {
   weak var view: WebViewViewControllerProtocol?

   func viewDidLoad() {
     setupUnsplashAuthWebView()
   }

   func didUpdateProgressValue(_ newValue: Double) {
     let newProgressValue = Float(newValue)
     view?.setProgressValue(newProgressValue)

     let shouldProgressHidden = shouldHideProgress(for: newProgressValue)
     view?.setProgressHidden(shouldProgressHidden)
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

 private extension WebViewPresenter {
  

   func shouldHideProgress(for value: Float) -> Bool {
     abs(value - 1.0) <= 0.0001
   }

   func setupUnsplashAuthWebView() {
     guard var urlComponents = URLComponents(string: Constants.authorizeURLString) else {
       preconditionFailure("Incorrect \(Constants.authorizeURLString) string")
     }
     urlComponents.queryItems = [
       URLQueryItem(name: WebKeyConstant.clientId, value: Constants.accessKey),
       URLQueryItem(name: WebKeyConstant.redirectUri, value: Constants.redirectURI),
       URLQueryItem(name: WebKeyConstant.responseType, value: Constants.code),
       URLQueryItem(name: WebKeyConstant.scope, value: Constants.accessScope)
     ]
     guard let url = urlComponents.url else {
       print(CancellationError())
       return
     }
     let request = URLRequest(url: url)

     didUpdateProgressValue(0)

     view?.load(request: request)
   }
 }
