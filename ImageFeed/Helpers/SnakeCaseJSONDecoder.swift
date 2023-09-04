//
//  SnakeCaseJSONDecoder.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 01.09.2023.
//

import Foundation

class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
