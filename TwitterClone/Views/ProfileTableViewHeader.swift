//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by omar thamri on 11/11/2023.
//

import UIKit


class ProfileTableViewHeader: UIView {
    
    private enum SectionTabs: String {
        case tweets = "Tweets"
        case tweetsAndReplies = "Tweets & Replies"
        case media = "Media"
        case likes = "Likes"
        
        var index: Int {
            switch self {
            case .tweets:
                return 0
            case .tweetsAndReplies:
                return 1
            case .media:
                return 2
            case .likes:
                return 3
            }
        }
    }
    
    private var selectedTab: Int = 0 {
        didSet {
            print(selectedTab)
        }
    }
    private var tabs: [UIButton] = ["Tweets","Tweets & Replies","Media","Likes"]
        .map { buttonTitle in
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.tintColor = .label
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    
    private lazy var sectionStack: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let profileAvatarImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.backgroundColor = .yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.text = "@WandaMaximov"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let displayNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Wanda Maximov"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userBioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "The strongest and cutest Avenger"
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileHeaderImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "header")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let joinDateImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar",withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let joinDateLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Joined April 4, 2014"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let followingCountLabel: UILabel = {
       let label = UILabel()
        label.text = "314"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followingTextLabel: UILabel = {
       let label = UILabel()
        label.text = "Following"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followersCountLabel: UILabel = {
       let label = UILabel()
        label.text = "1M"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followersTextLabel: UILabel = {
       let label = UILabel()
        label.text = "Followers"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        addSubview(profileHeaderImageView)
        addSubview(profileAvatarImageView)
        addSubview(displayNameLabel)
        addSubview(userNameLabel)
        addSubview(userBioLabel)
        addSubview(joinDateImageView)
        addSubview(joinDateLabel)
        addSubview(followingCountLabel)
        addSubview(followingTextLabel)
        addSubview(followersCountLabel)
        addSubview(followersTextLabel)
        addSubview(sectionStack)
        configureConstraints()
        configureStackButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackButtons() {
        for (i,button) in sectionStack.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else { return }
            button.tag = i
            button.addTarget(self, action: #selector(didTapTab), for: .touchUpInside)
        }
    }
    
    @objc func didTapTab(_ sender: UIButton) {
        guard let label = sender.titleLabel?.text else { return }
        switch label {
        case SectionTabs.tweets.rawValue:
            selectedTab = 0
        case SectionTabs.tweetsAndReplies.rawValue:
            selectedTab = 1
        case SectionTabs.media.rawValue:
            selectedTab = 2
        case SectionTabs.likes.rawValue:
            selectedTab = 3
        default:
            selectedTab = 0
        }
    }
    
    private func configureConstraints() {
        let profileHeaderImageViewConstraints = [
            profileHeaderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileHeaderImageView.topAnchor.constraint(equalTo: topAnchor),
            profileHeaderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileHeaderImageView.heightAnchor.constraint(equalToConstant: 150)
        ]
        let profileAvatarImageViewConstraints = [
            profileAvatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileAvatarImageView.centerYAnchor.constraint(equalTo: profileHeaderImageView.bottomAnchor, constant: 10),
            profileAvatarImageView.widthAnchor.constraint(equalToConstant: 80),
            profileAvatarImageView.heightAnchor.constraint(equalToConstant: 80)
        ]
        let displayNameLabelConstraints = [
            displayNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            displayNameLabel.topAnchor.constraint(equalTo: profileAvatarImageView.bottomAnchor, constant: 20)
        ]
        let userNameLabelConstraints = [
            userNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            userNameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 5)
        ]
        let userBioLabelConstraints = [
            userBioLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            userBioLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -5),
            userBioLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5)
        ]
        let joinDateImageViewConstraints = [
            joinDateImageView.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            joinDateImageView.topAnchor.constraint(equalTo: userBioLabel.bottomAnchor, constant: 5)
        ]
        let joinDateLabelConstraints = [
            joinDateLabel.leadingAnchor.constraint(equalTo: joinDateImageView.trailingAnchor, constant: 2),
            joinDateLabel.bottomAnchor.constraint(equalTo: joinDateImageView.bottomAnchor)
        ]
        let followingCountLabelConstraints = [
            followingCountLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            followersCountLabel.topAnchor.constraint(equalTo: joinDateLabel.bottomAnchor, constant: 10)
        ]
        let followingTextLabelConstraints = [
            followingTextLabel.leadingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor,constant: 4),
            followingTextLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
        let followersCountLabelConstraints = [
            followersCountLabel.leadingAnchor.constraint(equalTo: followingTextLabel.trailingAnchor,constant: 8),
            followersCountLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
        let followersTextLabelConstraints = [
            followersTextLabel.leadingAnchor.constraint(equalTo: followersCountLabel.trailingAnchor,constant: 4),
            followersTextLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
        let sectionStackConstraints = [
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            sectionStack.topAnchor.constraint(equalTo: followingCountLabel.bottomAnchor, constant: 5),
            sectionStack.heightAnchor.constraint(equalToConstant: 35)
        ]
        NSLayoutConstraint.activate(profileHeaderImageViewConstraints)
        NSLayoutConstraint.activate(profileAvatarImageViewConstraints)
        NSLayoutConstraint.activate(displayNameLabelConstraints)
        NSLayoutConstraint.activate(userNameLabelConstraints)
        NSLayoutConstraint.activate(userBioLabelConstraints)
        NSLayoutConstraint.activate(joinDateImageViewConstraints)
        NSLayoutConstraint.activate(joinDateLabelConstraints)
        NSLayoutConstraint.activate(followingCountLabelConstraints)
        NSLayoutConstraint.activate(followingTextLabelConstraints)
        NSLayoutConstraint.activate(followersCountLabelConstraints)
        NSLayoutConstraint.activate(followersTextLabelConstraints)
        NSLayoutConstraint.activate(sectionStackConstraints)
    }
    
    
}
