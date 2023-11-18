//
//  TweetComposeViewModel.swift
//  TwitterClone
//
//  Created by omar thamri on 17/11/2023.
//

import Foundation
import Combine
import FirebaseAuth

final class TweetComposeViewModel: ObservableObject {
    
    private var subscriptions: Set<AnyCancellable> = []
    @Published var isValidToTweet: Bool = false
    var tweetContent = ""
    @Published var shouldDismiss: Bool = false
    private var twitterUser: TwitterUser?
    @Published var error: String = ""
    
    func getUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUser(retrieve: userId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] twitterUser in
                self?.twitterUser = twitterUser
            }
            .store(in: &subscriptions)

    }
    
    func validateToTweet() {
        isValidToTweet = !tweetContent.isEmpty
    }
    
    func dispatchTweet() {
        guard let twitterUser = twitterUser else { return }
        let tweet = Tweet(author: twitterUser, authorId: twitterUser.id, tweetContent: tweetContent, likesCount: 0, likers: [], isReply: false, parentReference: nil)
        DatabaseManager.shared.collectionTweets(dispatch: tweet)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.shouldDismiss = state
            }
            .store(in: &subscriptions)

    }
    
}
