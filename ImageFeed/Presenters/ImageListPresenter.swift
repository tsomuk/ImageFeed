//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 30/12/2023.
//

import Foundation

public protocol ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    var photosTotalCount: Int { get }
    func updateTableViewAnimated()
    func calcHeightForRowAt(indexPath: IndexPath) -> CGFloat
    func checkNeedLoadNextPhotos (indexPath: IndexPath)
    func returnPhotoModelAt (indexPath: IndexPath) -> Photo?
}

// MARK: - Class

final class ImageListPresenter {
    
    private var imageListService = ImageListService.shared

  weak var view: ImagesListViewControllerProtocol?
  var photos: [Photo] = []
    var photosTotalCount: Int {
         photos.count
       }
}

extension ImageListPresenter: ImageListPresenterProtocol {
    
    func viewDidLoad() {
        setupImageListService()
        view?.setupTableView()
    }

  func updateTableViewAnimated() {
    let oldCount = photosTotalCount
    photos = imageListService.photos
    let newCount = photosTotalCount

    if oldCount != newCount {
      view?.tableView.performBatchUpdates {
        let indexes = (oldCount..<newCount).map { index in
          IndexPath(row: index, section: 0)
        }
        view?.tableView.insertRows(at: indexes, with: .automatic)
      }
    }
  }

  func checkNeedLoadNextPhotos (indexPath: IndexPath) {
    if indexPath.row + 2 == photosTotalCount {
      imageListService.fetchPhotoNextPage()
    }
  }

    func returnPhotoModelAt (indexPath: IndexPath) -> Photo? {
         photos[indexPath.row]
       }
    
  func calcHeightForRowAt(indexPath: IndexPath) -> CGFloat {
    guard let view else { return 0 }
    let imageInsets = (top: CGFloat(4), left: CGFloat(16), bottom: CGFloat(4), right: CGFloat(16))
    let thumbImageSize = photos[indexPath.row].thumbSize
    let imageViewWidth = view.tableView.bounds.width - imageInsets.left - imageInsets.right
    let imageWidth = thumbImageSize.width
    let scale = imageViewWidth / imageWidth
    let cellHeight = thumbImageSize.height * scale + imageInsets.top + imageInsets.bottom
    return cellHeight
  }
}

extension ImageListPresenter {
  func setupImageListService() {
    imageListService.fetchPhotoNextPage()
    updateTableViewAnimated()
  }
}

// MARK: - ImagesListCellDelegate

extension ImageListPresenter: ImagesListCellDelegate {
  // to presenter
  func imagesListCellDidTapLike(_ cell: ImagesListCell) {
    guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
    let photo = photos[indexPath.row]
    UIBlockingProgressHUD.show()
    imageListService.changeLike(photoId: photo.id, indexPath: indexPath, isLike: !photo.isLiked) { [weak self ] result in
      guard let self else { return }
      switch result {
      case .success(let isLiked):
        self.photos[indexPath.row].isLiked = isLiked
        cell.setIsLiked(isLiked)
        UIBlockingProgressHUD.dismiss()
      case .failure(let error):
        UIBlockingProgressHUD.dismiss()
        print("\(error.localizedDescription)")
        // TODO: Make & show alert
      }
    }
  }
}