//
//  ImageFeed_UnitTests.swift
//  ImageFeed_UnitTests
//
//  Created by Nikita Tsomuk on 29/12/2023.
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    
    func testPresenterCallsLoadRequest() {
      // given
      let viewController = WebViewViewControllerSpy()
      let authHelper = AuthHelper()
      let presenter = WebViewPresenter(authHelper: authHelper)
      viewController.presenter = presenter
      presenter.view = viewController

      // when
      presenter.viewDidLoad()

      // then
      XCTAssertTrue(viewController.loadRequestCalled)
    }
}
