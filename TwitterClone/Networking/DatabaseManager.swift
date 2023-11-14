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
}
