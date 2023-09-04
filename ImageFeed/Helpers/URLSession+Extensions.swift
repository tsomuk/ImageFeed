//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 01.09.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func fetchData(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let completionOnMainQueue: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data, let response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    completionOnMainQueue(.success(data))
                } else {
                    completionOnMainQueue(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error {
                completionOnMainQueue(.failure(NetworkError.urlRequestError(error)))
            } else {
                completionOnMainQueue(.failure(NetworkError.urlSessionError))
            }
        }        
        task.resume()
        return task
    }
}
