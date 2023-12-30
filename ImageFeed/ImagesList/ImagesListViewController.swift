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
}


final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
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
        configure(presenter)
        presenter.viewDidLoad()
        setupTableView()
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
            viewController.largeImageURL = URL(string: presenter.photos[indexPath.row].largeImageURL)
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

private extension ImagesListViewController {
    
    func configure(_ presenter: ImageListPresenterProtocol) {
      self.presenter = presenter
      self.presenter.view = self
    }
    
    
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
      presenter.photos.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath
    ) as? ImagesListCell else {
      return UITableViewCell()
    }
    cell.delegate = presenter as? any ImagesListCellDelegate

      if cell.loadCell(from: presenter.photos[indexPath.row]) {
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      presenter.calcHeightForRowAt(indexPath: indexPath)
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      presenter.checkNeedLoadNextPhotos(indexPath: indexPath)
    }
  }





