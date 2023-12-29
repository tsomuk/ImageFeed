//
//  WebViewPresenterSpy.swift
//  ImageFeed_UnitTests
//
//  Created by Nikita Tsomuk on 29/12/2023.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
  var viewDidLoadCalled = false
  var view: WebViewViewControllerProtocol?

  func viewDidLoad() {
    viewDidLoadCalled = true
  }

  func didUpdateProgressValue(_ newValue: Double) { }

  func code(from url: URL) -> String? {
    nil
  }
}


