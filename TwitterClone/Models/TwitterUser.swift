//
//  TwitterUser.swift
//  TwitterClone
//
//  Created by omar thamri on 14/11/2023.
//

import Foundation
import Firebase

struct TwitterUser: Codable {
    
    let id: String
    var displayName: String = ""
    var username: String = ""
    var followersCount: Int = 0
    var followingCount: Int = 0
    var createdOn: Date = Date()
    var bio: String = ""
    var avatarPath: String = ""
    var isUserOnBoarded: Bool = false
    
    init(from user: User) {
        self.id = user.uid
    }
}
