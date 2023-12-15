//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 09/12/2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}


struct PhotoResult: Codable {
    let id: String
    let createdAt, updatedAt: Date
    let width, height: Int
    let color, blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String
    let urls: Urls
    
    // MARK: - Urls
    struct Urls: Codable {
        let raw, full, regular, small: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case description, urls
    }
}




