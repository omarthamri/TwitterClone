//
//  StorageManager.swift
//  TwitterClone
//
//  Created by omar thamri on 16/11/2023.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum FirestorageError: Error {
    
    case invalidImageId
}


final class StorageManager {
    
    static let shared = StorageManager()
    let storage = Storage.storage()
    
    func getDownloadURL(for id: String?) -> AnyPublisher<URL,Error> {
        guard let id = id else {
            return Fail(error: FirestorageError.invalidImageId)
                .eraseToAnyPublisher()
        }
        return storage
            .reference(withPath: id)
            .downloadURL()
            .eraseToAnyPublisher()
    }
    
    func uploadProfilePhoto(with randomID: String,image: Data,metaData: StorageMetadata) -> AnyPublisher<StorageMetadata,Error> {
        return storage
            .reference()
            .child("images/\(randomID).jpeg")
            .putData(image, metadata: metaData)
            .eraseToAnyPublisher()
    }
    
}

