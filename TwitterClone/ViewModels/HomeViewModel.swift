//
//  HomeViewModel.swift
//  TwitterClone
//
//  Created by omar thamri on 14/11/2023.
//

import Foundation
import Combine
import Firebase

final class HomeViewModel: ObservableObject {
    
    @Published var twitterUser: TwitterUser?
    @Published var tweets: [Tweet] = []
    @Published var error: String?
    private var subscriptions: Set<AnyCancellable> = []
    
    func retrieveUser() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUser(retrieve: id)
            .handleEvents(receiveOutput: { [weak self] twitterUser in
                self?.twitterUser = twitterUser
                self?.fetchTweets()
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.twitterUser = user
            }
            .store(in: &subscriptions)

    }
    
    func fetchTweets() {
        DatabaseManager.shared.collectionTweets()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] retrievedTweets in
                self?.tweets = retrievedTweets
            }
            .store(in: &subscriptions)

    }
    
}
