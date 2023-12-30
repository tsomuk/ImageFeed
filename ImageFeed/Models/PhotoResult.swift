//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 09/12/2023.
//

import Foundation

public struct Photo {
  let id: String
  let size: CGSize
  let createdAt: Date?
  let welcomeDescription: String?
  let thumbImageURL: String
  let largeImageURL: String
  var isLiked: Bool
  let thumbSize: CGSize
}


struct PhotoResult: Codable {
    let id: String
    let width, height: Int
    let createdAt: String?
    let description: String?
    let likedByUser: Bool
    let urls: Urls
}
    
    // MARK: - Urls
    struct Urls: Codable {
        let full, small: String
    }
    
    struct LikeResult: Codable {
      let photo: PhotoLikeResult
    }

    struct PhotoLikeResult: Codable {
      let likedByUser: Bool
    }
    
    





