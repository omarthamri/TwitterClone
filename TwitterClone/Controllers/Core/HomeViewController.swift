//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by omar thamri on 9/11/2023.
//

import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {
    
    private var viewModel = HomeViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    lazy var timelineTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var composeTweetButton: UIButton = {
        let button = UIButton(type: .system,primaryAction: UIAction{ [weak self] _ in
            self?.navigateToTweetComposer()
        })
        button.backgroundColor = .twitterBlueColor
        button.tintColor = .white
        let plusSign = UIImage(systemName: "plus",withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
        button.setImage(plusSign, for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        view.addSubview(composeTweetButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(didTapSignOut))
        configureConstraints()
        bindViews()
    }
    
    @objc private func didTapSignOut() {
        try? Auth.auth().signOut()
        handleAuthentification()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        timelineTableView.frame = view.frame
        configureNavigationBar()
    }
    
    private func handleAuthentification() {
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
    private func navigateToTweetComposer() {
        let vc = UINavigationController(rootViewController: TweetComposeViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuthentification()
        viewModel.retrieveUser()
    }
    
    func completeUserOnBoarding() {
        let vc = ProfileDataFormViewController()
        present(vc, animated: true)
    }
    
    private func bindViews() {
        viewModel.$twitterUser.sink { [weak self] user in
            guard let user = user else { return }
            if !user.isUserOnBoarded {
                self?.completeUserOnBoarding()
            }
        }
        .store(in: &subscriptions)
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.timelineTableView.reloadData()
            }
        }
        .store(in: &subscriptions)
    }
    
    private func configureConstraints() {
        let composeTweetButtonConstraints = [
            composeTweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -25),
            composeTweetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            composeTweetButton.widthAnchor.constraint(equalToConstant: 60),
            composeTweetButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(composeTweetButtonConstraints)
    }
    
    private func configureNavigationBar() {
        let size: CGFloat = 36
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.image = UIImage(named: "twitter_logo")
        logoImageView.contentMode = .scaleAspectFill
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middleView.addSubview(logoImageView)
        navigationItem.titleView = middleView
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(profileTapped))
    }
    
    @objc func profileTapped() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else { return UITableViewCell() }
        cell.configureTweet(with: viewModel.tweets[indexPath.row].author.displayName, username: viewModel.tweets[indexPath.row].author.username, tweetContent: viewModel.tweets[indexPath.row].tweetContent, avatarPath: viewModel.tweets[indexPath.row].author.avatarPath)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
}


extension HomeViewController: TweetTableViewCellDelegate {
    func tweetTableViewCellDidTapReply() {
        print("reply")
    }
    
    func tweetTableViewCellDidTapRetweet() {
        print("tweet")
    }
    
    func tweetTableViewCellDidTapLike() {
        print("like")
    }
    
    func tweetTableViewCellDidTapShare() {
        print("share")
    }
    
    
    
    
    
}
