//
//  ImageListTests.swift
//  ImageFeed_UnitTests
//
//  Created by Nikita Tsomuk on 30/12/2023.
//

import XCTest
@testable import ImageFeed


final class ImageListTests: XCTestCase {
    
    let viewController = ImagesListViewController()
    let presenter = ImageListPresenterSpy()
    let indexPath = IndexPath(row: 1, section: 0)
    
    override func setUpWithError() throws {
        // given
        viewController.presenter = presenter
        presenter.view = viewController
    }
    
    func testViewControllerCallViewDidLoad() {
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    
}
