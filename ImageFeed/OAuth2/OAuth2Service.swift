//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 30.08.2023.
//

import Foundation

// MARK: - Constants

struct OAuth2Constants {
    static let authTokenURL = "https://unsplash.com/oauth/token"
    static let requestURL = "https://unsplash.com"
    static let requestPath = "/oauth/token"
    static let requestMethod = "POST"
    static let requestGrantType = "authorization_code"
    
    static let clientID = "client_id"
    static let clientSecret = "client_secret"
    static let redirectURI = "redirect_uri"
    static let grandType = "grant_type"
    static let code = "code"
}

// MARK: - OAuth2Service

final class OAuth2Service {
    
    private let urlSession: URLSession
    private var storage: OAuth2TokenStorage
    private var task : URLSessionTask?
    private var lastCode : String?
    
    static let shared = OAuth2Service()
    
    init(urlSession: URLSession = .shared, storage: OAuth2TokenStorage = .shared) {
        self.urlSession = urlSession
        self.storage = storage
        
    }
    
    var isAuthenticated: Bool {
        storage.token != nil
    }
}

private extension OAuth2Service {

    var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
}


// MARK: - OAuth2Service - fetchAuthToken

extension OAuth2Service {
    
    func fetchAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        guard code != lastCode else { return }
        task?.cancel()
        lastCode = code
        print("✅", "LastCode:",lastCode)
        
        guard let request = makeRequest(code: code) else {
            assertionFailure("Error Reguest")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task = urlSession.objectTask(for: request) {
            [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { preconditionFailure("Can't make weak link") }
            self.task = nil
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.storage.token = authToken
                completion(.success(authToken))
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
            }
        }
        
        
        func makeRequest(code: String) -> URLRequest? {
            
            var urlComponents = URLComponents(string: OAuth2Constants.authTokenURL)
            urlComponents?.queryItems = [
                URLQueryItem(name: OAuth2Constants.clientID, value: accessKey),
                URLQueryItem(name: OAuth2Constants.clientSecret, value: secretKey),
                URLQueryItem(name: OAuth2Constants.redirectURI, value: redirectURI),
                URLQueryItem(name: OAuth2Constants.code, value: code),
                URLQueryItem(name: OAuth2Constants.grandType, value: OAuth2Constants.requestGrantType)
            ]
            
            guard let urlWithQuery = urlComponents?.url else {
                preconditionFailure("Не удается создать URL с параметрами")
            }
            
            var request = URLRequest(url: urlWithQuery)
            request.httpMethod = OAuth2Constants.requestMethod
            
            return request
        }
    }
}


