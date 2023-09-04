//
//  URLRequest+Extensions.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 01.09.2023.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String?,
        baseURL: URL? = defaultBaseURL
    ) -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else { preconditionFailure("Cannot make url") }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
