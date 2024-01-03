//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 27/11/2023.
//

import Foundation

struct ProfileConstants {
    static let requestURL = "https://unsplash.com/me"
}

protocol ProfileLoading: AnyObject {
  func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void)
}

final class ProfileService {
  
  static let shared = ProfileService()

  private let urlSession: URLSession
  private let requestBuilder: URLRequestBuilder

  private var currentTask: URLSessionTask?
  private (set) var profile: Profile?

  init(urlSession: URLSession = .shared, requestBuilder: URLRequestBuilder = .shared) {
    self.urlSession = urlSession
    self.requestBuilder = requestBuilder
  }
}

private extension ProfileService {

  func makeProfileRequest() -> URLRequest? {
    requestBuilder.makeHTTPRequest(path: Constants.profileRequestPathString)
  }
}

extension ProfileService: ProfileLoading {

  func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {

    assert(Thread.isMainThread)
    currentTask?.cancel()

    guard let request = makeProfileRequest() else {
      assertionFailure("Invalid request")
      completion(.failure(NetworkError.invalidRequest))
      return
    }

    let session = URLSession.shared
    let task = session.objectTask(for: request) {
      [weak self] (result: Result<ProfileResult, Error>) in

      guard let self else { preconditionFailure("Can't make weak link") }

      self.currentTask = nil

      switch result {
      case .success(let profileResult):
        let profile = Profile(result: profileResult)
        self.profile = profile
        completion(.success(profile))
      case .failure(let error):
        completion(.failure(error))
      }
    }
      self.currentTask = task
      task.resume()
  }
}
