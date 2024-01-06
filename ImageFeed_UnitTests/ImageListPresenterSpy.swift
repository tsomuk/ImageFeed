//
//  ImageListPresenterSpy.swift
//  ImageFeed_UnitTests
//
//  Created by Nikita Tsomuk on 30/12/2023.
//

import Foundation
import ImageFeed

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    var photosTotalCount: Int = 0
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var updateTableViewAnimatedCalled = false
    
    var calcHeightForRowAtCalled = false
    var calcHeightForRowAtGotIndex = false
    
    var checkNeedLoadNextPhotosCalled = false
    var checkNeedLoadNextPhotosGotIndex = false
    
    var returnPhotoModelAtCalled = false
    var returnPhotoModelAtGotIndex = false
    
    var imagesListCellDidTapLikeCalled = false
    var imagesListCellDidTapLikeGotIndex = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
    
    func calcHeightForRowAt(indexPath: IndexPath) -> CGFloat {
        calcHeightForRowAtCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            calcHeightForRowAtGotIndex = true
        }
        return CGFloat(100)
    }
    
    func checkNeedLoadNextPhotos(indexPath: IndexPath) {
        checkNeedLoadNextPhotosCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            checkNeedLoadNextPhotosGotIndex = true
        }
    }
    
    func returnPhotoModelAt(indexPath: IndexPath) -> ImageFeed.Photo? {
        returnPhotoModelAtCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            returnPhotoModelAtGotIndex = true
        }
        return nil
    }
    
    func imagesListCellDidTapLike(_ cell: ImageFeed.ImagesListCell, indexPath: IndexPath) {
        imagesListCellDidTapLikeCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            imagesListCellDidTapLikeGotIndex = true
        }
    }
}
