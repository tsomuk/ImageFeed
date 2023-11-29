//
//  ProfileStructures.swift
//  ImageFeed
//
//  Created by Nikita Tsomuk on 29/11/2023.
//

import Foundation

struct ProfileResults : Codable {
    var userLogin    : String
    var firstName    : String?
    var lastName     : String?
    var bio          : String?
    var profileImage : ProfileImage?
    
    private enum CodingKeys: String, CodingKey {
        case userLogin    = "username"
        case firstName    = "first_name"
        case lastName     = "last_name"
        case bio
        case profileImage = "profile_image"
    }
    
    struct ProfileImage: Codable {
        let small : String?
        let medium : String?
        let large : String?
    }
    
}

struct Profile : Codable {
    var username  : String
    var name      : String
    var loginName : String
    var bio       : String?
}

extension Profile {
    init(result profile: ProfileResults) {
        self.init(
            username: profile.userLogin,
            name: "\(profile.firstName ?? "") \(profile.lastName ?? "")",
            loginName: "@\(profile.userLogin)",
            bio: profile.bio
        )
    } 
}

