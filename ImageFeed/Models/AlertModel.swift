//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 04/12/2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
