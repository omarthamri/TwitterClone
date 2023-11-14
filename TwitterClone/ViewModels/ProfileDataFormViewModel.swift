//
//  ProfileDataFormViewModel.swift
//  TwitterClone
//
//  Created by omar thamri on 14/11/2023.
//

import Foundation
import Combine


final class ProfileDataFormViewModel: ObservableObject {
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    
}
