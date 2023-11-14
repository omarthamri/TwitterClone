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
    @Published var error: String?
    private var subscriptions: Set<AnyCancellable> = []
    
    func retrieveUser() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUser(retrieve: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.twitterUser = user
            }
            .store(in: &subscriptions)

    }
    
}
