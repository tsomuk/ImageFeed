//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 02.07.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
   
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var favoriteSign: UIButton!
    @IBOutlet weak var dataLabel: UILabel!
    
}
