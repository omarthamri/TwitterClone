//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by omar thamri on 10/11/2023.
//

import UIKit
import Combine
import SDWebImage


class ProfileViewController: UIViewController {
    
    private var isstatusBarHidden: Bool = true
    private var viewModel = ProfileViewModel()
    
    private let statusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
    }()
    
    private let profileTableView: UITableView = {
       let table = UITableView()
        table.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
       return table
    }()
    
    private lazy var profileTableViewHeader = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.bounds.width, height: 380))
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        view.addSubview(profileTableView)
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.tableHeaderView = profileTableViewHeader
        profileTableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true
        view.addSubview(statusBar)
        configureConstraints()
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retrieveUser()
    }
    
    private func bindViews() {
        viewModel.$twitterUser.sink { [weak self] twitterUser in
            guard let twitterUser = twitterUser else { return }
            self?.profileTableViewHeader.displayNameLabel.text = twitterUser.displayName
            self?.profileTableViewHeader.userNameLabel.text = "@\(twitterUser.username)"
            self?.profileTableViewHeader.userBioLabel.text = twitterUser.bio
            self?.profileTableViewHeader.joinDateLabel.text = "Joined \(String(describing: self?.viewModel.getFormattedDate(with: twitterUser.createdOn) ?? ""))"
            self?.profileTableViewHeader.followersCountLabel.text = "\(twitterUser.followersCount)"
            self?.profileTableViewHeader.followingCountLabel.text = "\(twitterUser.followingCount)"
            self?.profileTableViewHeader.profileAvatarImageView.sd_setImage(with: URL(string: twitterUser.avatarPath))
        }
        .store(in: &subscriptions)
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.profileTableView.reloadData()
            }
        }
        .store(in: &subscriptions)
    }
    
    private func configureConstraints() {
        let profileTableViewConstraints = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        let statusBarConstaints = [
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ]
        NSLayoutConstraint.activate(profileTableViewConstraints)
        NSLayoutConstraint.activate(statusBarConstaints)
    }
    
    
}

extension ProfileViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else { return UITableViewCell() }
        cell.configureTweet(with: viewModel.tweets[indexPath.row].author.displayName, username: viewModel.tweets[indexPath.row].author.username, tweetContent: viewModel.tweets[indexPath.row].tweetContent, avatarPath: viewModel.tweets[indexPath.row].author.avatarPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yposition = scrollView.contentOffset.y
        if yposition > 150 && isstatusBarHidden {
            isstatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0,options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 1
            }
        } else if yposition < 0 && !isstatusBarHidden {
            isstatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0,options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 0
            }
        }
    }
}
