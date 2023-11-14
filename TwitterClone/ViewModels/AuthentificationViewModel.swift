//
//  RegisterViewModel.swift
//  TwitterClone
//
//  Created by omar thamri on 12/11/2023.
//

import Foundation
import Firebase
import Combine

final class AuthentificationViewModel: ObservableObject {
    
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthentificationFormValid: Bool = false
    @Published var user: User?
    private var subscriptions: Set<AnyCancellable> = []
    @Published var error: String?
    
    func validateAuthentificationForm() {
        guard let email = email, let password = password else {
            isAuthentificationFormValid = false
            return
        }
        isAuthentificationFormValid = isValidEmail(email) && password.count >= 6
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func registerUser() {
        guard let email = email, let password = password else {
            print("failed to register user")
            return
        }
        AuthManager.shared.registerUser(with: email, password: password)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)

    }
    
    func loginUser() {
        guard let email = email, let password = password else {
            print("failed to register user")
            return
        }
        AuthManager.shared.login(with: email, password: password)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
                
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)

    }
    
}
