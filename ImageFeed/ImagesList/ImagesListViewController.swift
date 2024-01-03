//
//  ViewController.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 02.07.2023.
//

import UIKit

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol { get set }
    var tableView: UITableView! { get set }
    func setupTableView()
}

final class ImagesListViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Private properties
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var imageListServiceObserver: NSObjectProtocol?
    
    var presenter = ImageListPresenter() as ImageListPresenterProtocol
    // MARK: - Public properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupNotificationObserver()
        view.addSubview(tableView)
    }
    
    //   MARK: - public methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

      if segue.identifier == showSingleImageSegueIdentifier {
        guard
          let viewController = segue.destination as? SingleImageViewController,
          let indexPath = sender as? IndexPath
        else {
          super.prepare(for: segue, sender: sender)
          return
        }
        guard let photo = presenter.returnPhotoModelAt(indexPath: indexPath) else {
          preconditionFailure("Cannot take photo from the array")
        }
        viewController.largeImageURL = URL(string: photo.largeImageURL)
      } else {
        super.prepare(for: segue, sender: sender)
      }
    }
  }

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

// MARK: - private methods

extension ImagesListViewController: ImagesListViewControllerProtocol {
        
  func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
  }

   func setupNotificationObserver() {
    imageListServiceObserver = NotificationCenter.default
      .addObserver(
        forName: ImageListService.didChangeNotification,
        object: nil,
        queue: .main
      ) { [weak self] _ in
          self?.presenter.updateTableViewAnimated()
      }
  }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      presenter.photosTotalCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath
    ) as? ImagesListCell else {
      return UITableViewCell()
    }
    cell.delegate = presenter as? any ImagesListCellDelegate
      guard let photo = presenter.returnPhotoModelAt(indexPath: indexPath) else {
        preconditionFailure("Can't take photo from the array")
      }
      if cell.loadCell(from: photo) {
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      presenter.calcHeightForRowAt(indexPath: indexPath)
  }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let visibleRows = tableView.indexPathsForVisibleRows, indexPath == visibleRows.last {
            presenter.checkNeedLoadNextPhotos(indexPath: indexPath)
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
  func imagesListCellDidTapLike(_ cell: ImagesListCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    presenter.imagesListCellDidTapLike(cell, indexPath: indexPath)
  }
}
