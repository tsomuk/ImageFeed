//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 30.08.2023.
//

import Foundation


// MARK: - OAuth2Service

final class OAuth2Service {
    
    private let urlSession = URLSession.shared
    static let shared = OAuth2Service()
    private init() { }
    
}

private extension OAuth2Service {
    enum OAuth2Constants {
        static let tokenURLString = "https://unsplash.com/oauth/token"
        static let tokenRequestURLString = "https://unsplash.com"
        static let tokenRequestPathString = "/oauth/token"
        static let tokenRequestMethodString = "POST"
        static let tokenRequestGrantTypeString = "authorization_code"
    }
    
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
        guard let url = URL(string: OAuth2Constants.tokenRequestURLString) else { preconditionFailure("Cannot make url") }
        return URLRequest.makeHTTPRequest(
            path: OAuth2Constants.tokenRequestPathString
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=\(OAuth2Constants.tokenRequestGrantTypeString)",
            httpMethod: OAuth2Constants.tokenRequestMethodString,
            baseURL: url)
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
