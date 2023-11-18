//
//  DatabaseManager.swift
//  TwitterClone
//
//  Created by omar thamri on 14/11/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine

class DatabaseManager {
    
    static let shared = DatabaseManager()
    let db = Firestore.firestore()
    let usersPath = "users"
    let tweetsPath = "tweets"
    func collectionUsers(with user: User) -> AnyPublisher<Bool,Error> {
        let twitterUser = TwitterUser(from: user)
        return db.collection(usersPath).document(twitterUser.id).setData(from: twitterUser)
            .map { _ in
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func collectionUser(retrieve id: String) -> AnyPublisher<TwitterUser,Error> {
        db.collection(usersPath).document(id).getDocument()
            .tryMap({try $0.data(as: TwitterUser.self)})
            .eraseToAnyPublisher()
    }
    
    func collectionUser(updateFields: [String: Any], for id: String) -> AnyPublisher<Bool,Error> {
        db.collection(usersPath).document(id).updateData(updateFields)
            .map({_ in true})
            .eraseToAnyPublisher()
    }
    
    func collectionTweets(dispatch tweet: Tweet) -> AnyPublisher<Bool,Error> {
        db.collection(tweetsPath).document(tweet.id).setData(from: tweet)
            .map({_ in true})
            .eraseToAnyPublisher()
    }
    
    func collectionTweets() -> AnyPublisher<[Tweet],Error> {
        db.collection(tweetsPath)
            .getDocuments()
            .tryMap(\.documents)
            .tryMap { snapshots in
                try snapshots.map { singularSnapshot in
                    try singularSnapshot.data(as: Tweet.self)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func collectionTweets(retrieveTweets forUserId: String) -> AnyPublisher<[Tweet],Error> {
        db.collection(tweetsPath).whereField("authorId", isEqualTo: forUserId)
            .getDocuments()
            .tryMap(\.documents)
            .tryMap { snapshots in
                try snapshots.map { singularSnapshot in
                    try singularSnapshot.data(as: Tweet.self)
                }
            }
            .eraseToAnyPublisher()
    }
    
}
