//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 31.08.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    var accessToken  : String
    var tokenType    : String
    var scope        : String
    var createdAt    : Int
}



// MARK: - Example of the answer
//{
//  "access_token": "091343ce13c8ae780065ecb3b13dc903475dd22cb78a05503c2e0c69c5e98044",
//  "token_type": "bearer",
//  "scope": "public read_photos write_photos",
//  "created_at": 1436544465
//}
