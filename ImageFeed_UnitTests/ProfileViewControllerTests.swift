//
//  ProfileViewControllerTests.swift
//  ImageFeed_UnitTests
//
//  Created by Nikita Tsomuk on 29/12/2023.
//

import XCTest
@testable import ImageFeed



final class ProfileViewControllerTests: XCTestCase {
    
    let viewController = ProfileViewControllerSpy()
    let presenter = ProfilePresenter()
    
    func testPresenterCallsLoadProfile() {
      // given
      let testUser = "test"
      let testProfile = Profile(username: testUser, name: testUser, loginName: testUser, bio: testUser)

      // when
      viewController.loadProfile(testProfile)

      // then
      XCTAssertTrue(viewController.viewDidLoadProfile)
      XCTAssertEqual(viewController.descriptionLabel.text, testUser)
      XCTAssertEqual(viewController.userNameLabel.text, testUser)
      XCTAssertEqual(viewController.loginLabel.text, testUser)
    }
    
    
}
