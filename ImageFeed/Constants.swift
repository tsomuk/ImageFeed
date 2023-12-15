//
//  Constants.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 29.08.2023.
//

import Foundation


public enum Constants {
    
    // Unsplash const
    static let secretKey = "Nt04IHldFukSep8Cbvy4w2Spkp9B33bfEmcMSN5Z3zU"
    static let accessKey = "TIIkrtuIhItIuiCkXyZGRDj3K_AJNTGRguzhj-u5wmQ"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    
    // Unsplash urls
    static let defaultApiBaseURLString = "https://api.unsplash.com"
    static let profileRequestPathString = "/me"
    static let photoPathString = "/photos"

    // HTTP methods
    static let getMethodString = "GET"
    static let postMethodString = "POST"

    // Storage const
    static let bearerToken = "bearerToken"
    
    // Data formatter
    static let dateTimeDefaultFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY HH:mm"
        return dateFormatter
    }()
}
