//
//  Tweet.swift
//  TwitterClone
//
//  Created by omar thamri on 17/11/2023.
//

import Foundation

struct Tweet: Codable {
    
    let id: String = UUID().uuidString
    let author: TwitterUser
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
}
