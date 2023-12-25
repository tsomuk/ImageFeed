//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 02.07.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
  func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var dataLabel: UILabel!

    private let placeholderImage = UIImage(named: "placeholder")

    // MARK: - Public properties
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    override func prepareForReuse() {
      super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }

    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.imagesListCellDidTapLike(self)
    }
  }

  // MARK: - Methods

  extension ImagesListCell {
      
      func setIsLiked(_ isLiked: Bool) {
        let likedImage = isLiked ? UIImage(named: "like") : UIImage(named: "no_like")
          favoriteButton.setImage(likedImage, for: .normal)
      }

    func loadCell(from photo: Photo) -> Bool {
      var status = false

      if let photoDate = photo.createdAt {
          dataLabel.text = Constants.dataFormater.string(from: photoDate)
      } else {
          dataLabel.text = ""
      }
        
        setIsLiked(photo.isLiked)

      guard let photoURL = URL(string: photo.thumbImageURL) else { return status }

        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: photoURL, placeholder: placeholderImage) { [weak self] result in
        guard let self else { return }
        switch result {
        case .success(_):
          status = true
        case .failure(let error):
            cellImage.image = placeholderImage
            debugPrint("Error: \(error.localizedDescription)")
        }
      }
      return status
    }
  }
    
    
    
    
    
    
    

