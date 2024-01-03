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
    static let baseURLString = "https://unsplash.com"
    static let defaultApiBaseURLString = "https://api.unsplash.com"
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
    static let authorizedURLPath = "/oauth/authorize/native"
    static let profileRequestPathString = "/me"
    static let photoPathString = "/photos"
    
    // HTTP methods
    static let getMethodString = "GET"
    static let postMethodString = "POST"
    static let deleteMethodString = "DELETE"

    // Storage const
    static let bearerToken = "bearerToken"
    static let code = "code"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let apiURLString: String
    let authURLString: String
    let baseURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 apiURLString: Constants.defaultApiBaseURLString,
                                 authURLString: Constants.authorizeURLString,
                                 baseURLString: Constants.baseURLString)
        
    }
}

