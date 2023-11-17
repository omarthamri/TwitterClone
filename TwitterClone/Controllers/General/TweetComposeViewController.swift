//
//  TweetComposeViewController.swift
//  TwitterClone
//
//  Created by omar thamri on 17/11/2023.
//

import UIKit
import Combine


class TweetComposeViewController: UIViewController {
    
    private var viewModel = TweetComposeViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var tweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .twitterBlueColor
        button.setTitle("Tweet", for: .normal)
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.clipsToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(tweetBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tweetContentTextView: UITextView = {
       let textView = UITextView()
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "What's happening?"
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .gray
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Tweet"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        view.addSubview(tweetButton)
        view.addSubview(tweetContentTextView)
        configureConstraints()
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getUserData()
    }
    
    private func bindViews() {
        viewModel.$isValidToTweet.sink { [weak self] state in
            self?.tweetButton.isEnabled = state
        }
        .store(in: &subscriptions)
        viewModel.$shouldDismiss.sink { [weak self] shouldDismiss in
            if shouldDismiss {
                self?.dismiss(animated: true)
            }
        }
        .store(in: &subscriptions)
    }
    
    @objc func tweetBtnTapped() {
        viewModel.dispatchTweet()
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
    
    private func configureConstraints() {
        let tweetButtonConstraints = [
            tweetButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor,constant: -10),
            tweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tweetButton.widthAnchor.constraint(equalToConstant: 120),
            tweetButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        let tweetContentTextViewConstraints = [
            tweetContentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tweetContentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tweetContentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tweetContentTextView.bottomAnchor.constraint(equalTo: tweetButton.topAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(tweetButtonConstraints)
        NSLayoutConstraint.activate(tweetContentTextViewConstraints)
    }
    
}


extension TweetComposeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's happening?"
            textView.textColor = .gray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        viewModel.tweetContent = textView.text
        viewModel.validateToTweet()
    }
}
