//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 31.08.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    var accessToken : String
    var tokenType : String
    var scope: String
    var createdAt : Int
  
}
