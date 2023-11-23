//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 30.08.2023.
//

import Foundation

// MARK: - Constants

struct OAuth2Constants {
    static let tokenURLString = "https://unsplash.com/oauth/token"
    static let tokenRequestURLString = "https://unsplash.com"
    static let tokenRequestPathString = "/oauth/token"
    static let tokenRequestMethodString = "POST"
    static let tokenRequestGrantTypeString = "authorization_code"
    
    static let clientID = "client_id"
    static let clientSecret = "client_secret"
    static let redirectURI = "redirect_uri"
    static let grandType = "grant_type"
    static let code = "code"
}

// MARK: - OAuth2Service

final class OAuth2Service {
    private let urlSession = URLSession.shared
    static let shared = OAuth2Service()
    private init() { }
}

private extension OAuth2Service {
   
    enum NetworkError: Error {
        case codeError
    }
    
    var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
}

// MARK: - OAuth2Service

private extension OAuth2Service {
    func fetchOAuthTokenResponseBody(
        for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let completionOnMainQueue: (Result<OAuthTokenResponseBody, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let decoder = SnakeCaseJSONDecoder()
        return urlSession.fetchData(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completionOnMainQueue(response)
        }
    }
    
    func authTokenRequest(code: String) -> URLRequest {
        guard let url = URL(string: OAuth2Constants.tokenRequestURLString) else { preconditionFailure("Can't make url")
        }
        
        var urlComponents = URLComponents(string: OAuth2Constants.tokenURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: OAuth2Constants.clientID, value: accessKey),
            URLQueryItem(name: OAuth2Constants.clientSecret, value: secretKey),
            URLQueryItem(name: OAuth2Constants.redirectURI, value: redirectURI),
            URLQueryItem(name: OAuth2Constants.code, value: code),
            URLQueryItem(name: OAuth2Constants.grandType, value: "authorization_code")
        ]
        
        guard let urlWithQuery = urlComponents.url else {
                preconditionFailure("Не удается создать URL с параметрами")
            }

            var request = URLRequest(url: urlWithQuery)
            request.httpMethod = OAuth2Constants.tokenRequestMethodString

            return request
    }
}
    // MARK: - OAuth2Service - AuthRouting
    
    extension OAuth2Service {
        func fetchAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
            let completionOnMainQueue: (Result<String, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            let request = authTokenRequest(code: code)
            let task = fetchOAuthTokenResponseBody(for: request) { [weak self] result in
                guard let self else { preconditionFailure("Cannot make weak link") }
                switch result {
                case .success(let body):
                    self.authToken = body.accessToken
                    completionOnMainQueue(.success(body.accessToken))
                case .failure(let error):
                    completionOnMainQueue(.failure(error))
                }
            }
            task.resume()
        }
    }

