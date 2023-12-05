//
//  Constants.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 29.08.2023.
//

import Foundation


public let secretKey = "Nt04IHldFukSep8Cbvy4w2Spkp9B33bfEmcMSN5Z3zU"
public let accessKey = "TIIkrtuIhItIuiCkXyZGRDj3K_AJNTGRguzhj-u5wmQ"
public let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
public let accessScope = "public+read_user+write_likes"

public let defaultBaseURL = URL(string: "https://api.unsplash.com/")!



public enum Constants {
    static let defaultApiBaseURLString = "https://api.unsplash.com"
    static let secretKey: String = "Nt04IHldFukSep8Cbvy4w2Spkp9B33bfEmcMSN5Z3zU"
    static let profileRequestPathString = "/me"
    static let getMethodString = "GET"
    static let bearerToken = "bearerToken"
}
