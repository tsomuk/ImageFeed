//
//  ProfileStructures.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 29/11/2023.
//

import Foundation

public struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
}

public struct Profile {
  let username: String
 public let name: String
 public let loginName: String
 public let bio: String?
}

struct ProfileImage: Codable {
  let small: String?
  let medium: String?
  let large: String?
}


// MARK: - Init for ProfileResult

extension Profile {

  init(result profile: ProfileResult) {
    self.init(
      username: profile.username,
      name: "\(profile.firstName ?? "") \(profile.lastName ?? "")",
      loginName: "@\(profile.username)",
      bio: profile.bio
    )
  }
}
