//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by omar thamri on 10/11/2023.
//

import UIKit


class ProfileViewController: UIViewController {
    
    private let profileTableView: UITableView = {
       let table = UITableView()
        table.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
       return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        view.addSubview(profileTableView)
        let profileTableViewHeader = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.bounds.width, height: 380))
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.tableHeaderView = profileTableViewHeader
        configureConstraints()
    }
    
    private func configureConstraints() {
        let profileTableViewConstraints = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(profileTableViewConstraints)
    }
    
    
}

extension ProfileViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else { return UITableViewCell() }
        return cell
    }
    
}
