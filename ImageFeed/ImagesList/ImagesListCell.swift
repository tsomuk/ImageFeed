//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 02.07.2023.
//

import UIKit


 class ImagesListCell: UITableViewCell {
    
     @IBOutlet weak var cellImage: UIImageView!
     @IBOutlet weak var favoriteSign: UIButton!
     @IBOutlet weak var dataLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
    
}
