//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by omar thamri on 9/11/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var timelineTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        timelineTableView.frame = view.frame
        configureNavigationBar()
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else { return UITableViewCell() }
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
