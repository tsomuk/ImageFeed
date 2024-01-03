//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 02.07.2023.
//

import UIKit


protocol ImagesListCellDelegate: AnyObject {
  func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

public final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!

    private let placeholderImage = UIImage(named: "placeholder")
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        return dateFormatter
    }()

    // MARK: - Public properties
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    public override func prepareForReuse() {
      super.prepareForReuse()
        setIsLiked(false)
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
            dateLabel.text = dateFormatter.string(from: photoDate)
        } else {
            dateLabel.text = ""
        }
        favoriteButton.accessibilityIdentifier = "LikeButton"
        setIsLiked(photo.isLiked)
        guard let photoURL = URL(string: photo.thumbImageURL) else { return status }
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: photoURL, placeholder: placeholderImage) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                status = true
            case .failure(let error):
                cellImage.image = placeholderImage
                debugPrint("Error: \(error.localizedDescription)")
            }
        }
        return status
    }
}

    
    
    
    
    
    

