//
//  ProfileDataFormViewModel.swift
//  TwitterClone
//
//  Created by omar thamri on 14/11/2023.
//

import UIKit
import Combine
import FirebaseAuth
import FirebaseStorage


final class ProfileDataFormViewModel: ObservableObject {
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    @Published var imageData: UIImage?
    @Published var isFormValid: Bool = false
    @Published var error: String = ""
    @Published var isOnBoardingFinished: Bool = false
    private var subscriptions: Set<AnyCancellable> = []
    
    func validateUserProfileForm() {
        guard let displayName = displayName,
              displayName.count > 2,
              let username = username,
              username.count > 2,
              let bio = bio,
              bio.count > 2,
              imageData != nil else {
            isFormValid = false
            return
        }
        isFormValid = true
    }
    
    func uploadAvatar() {
        let randomId = UUID().uuidString
        guard let imageData = imageData?.jpegData(compressionQuality: 0.5) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        StorageManager.shared.uploadProfilePhoto(with: randomId, image: imageData, metaData: metaData)
            .flatMap({ metadata in
                StorageManager.shared.getDownloadURL(for: metadata.path )
            })
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.error = error.localizedDescription
                case .finished:
                    self?.uploadUserData()
                }
            } receiveValue: { [weak self] url in
                self?.avatarPath = url.absoluteString
            }
            .store(in: &subscriptions)

    }
    
    private func uploadUserData() {
        guard let displayName,
              let username,
              let bio,
              let avatarPath,
              let id = Auth.auth().currentUser?.uid else { return }
        let udpatedFields: [String: Any] = [
            "displayName": displayName,
            "username": username,
            "bio": bio,
            "avatarPath": avatarPath,
            "isUserOnBoarded": true
        ]
        DatabaseManager.shared.collectionUser(updateFields: udpatedFields, for: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print(error)
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] onBoardingState in
                self?.isOnBoardingFinished = onBoardingState
            }
            .store(in: &subscriptions)

    }
    
}
