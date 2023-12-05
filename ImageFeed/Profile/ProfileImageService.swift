//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 29/11/2023.
//

import Foundation

protocol ProfileImageLoading: AnyObject {
  func fetchProfileImageURL(userName: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class ProfileImageService {
  
  static let shared = ProfileImageService()
  static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

  private let session = URLSession.shared
  private let requestBuilder = URLRequestBuilder.shared

  private var currentTask: URLSessionTask?
  private (set) var avatarURL: URL?

  private init() { }
}

private extension ProfileImageService {

  func makeRequest(userName: String) -> URLRequest? {
    requestBuilder.makeHTTPRequest(path: "/users/\(userName)")
  }
}

// MARK: - ProfileLoading

extension ProfileImageService: ProfileImageLoading {
    

  func fetchProfileImageURL(userName: String, completion: @escaping (Result<String, Error>) -> Void) {

    assert(Thread.isMainThread)

    currentTask?.cancel()

    guard let request = makeRequest(userName: userName) else {
      assertionFailure("Invalid request")
      completion(.failure(NetworkError.invalidRequest))
      return
    }

    let task = session.objectTask(for: request) {
      [weak self] (result: Result<ProfileResult, Error>) in

      guard let self else { preconditionFailure("Cannot make weak link") }

      switch result {
      case .success(let profileResult):
        guard let mediumPhoto = profileResult.profileImage?.medium else { return }
        self.avatarURL = URL(string: mediumPhoto)
        completion(.success(mediumPhoto))
        NotificationCenter.default.post(
          name: ProfileImageService.didChangeNotification,
          object: self,
          userInfo: [Notification.userInfoImageURLKey: mediumPhoto]
        ) 
      case .failure(let error):
        completion(.failure(error))
      }
      self.currentTask = nil
    }

    self.currentTask = task
    task.resume()
  }
}
