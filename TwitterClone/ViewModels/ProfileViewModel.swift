//
//  ProfileViewModel.swift
//  TwitterClone
//
//  Created by omar thamri on 17/11/2023.
//

import Foundation
import Combine
import Firebase


final class ProfileViewModel: ObservableObject {
    
    @Published var twitterUser: TwitterUser?
    @Published var tweets: [Tweet] = []
    @Published var error: String?
    private var subscriptions: Set<AnyCancellable> = []
    
    func retrieveUser() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUser(retrieve: id)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.fetchTweets(id: id)
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
    
    func getFormattedDate(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYYY"
        return dateFormatter.string(from: date)
    }
    
    func fetchTweets(id: String) {
        DatabaseManager.shared.collectionTweets(retrieveTweets: id)
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
