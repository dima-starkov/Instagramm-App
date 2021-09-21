//
//  UserFollowTableViewCell.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 25.08.2021.
//

import UIKit

protocol UserFollowTableViewCellDelegate: AnyObject {
    func didTapFollowUnfollowButton(model: UserRelationship)
}

enum FollowState {
    case following,not_following
}

struct UserRelationship {
    let userName: String
    let name: String
    let type: FollowState
}

class UserFollowTableViewCell: UITableViewCell {

    static let identifier = "UserFollowTableViewCell"
    
    weak var delegate: UserFollowTableViewCellDelegate?
    
    private var model: UserRelationship?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = "Dima"
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "@dima"
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(followButton)
        selectionStyle = .none
        
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
    }
    
    @objc private func didTapFollowButton() {
        guard let model = model else { return }
        delegate?.didTapFollowUnfollowButton(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserRelationship){
        self.model = model
        nameLabel.text = model.name
        userNameLabel.text = model.userName
        switch model.type {
        case .following:
            //show unfollow button
            followButton.setTitle("Unfollow", for: .normal)
            followButton.setTitleColor(.label, for: .normal)
            followButton.backgroundColor = .systemBackground
            followButton.layer.borderColor = UIColor.label.cgColor
            followButton.layer.borderWidth = 1
        case .not_following:
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = .link
            followButton.layer.borderWidth = 0
            //show follow button
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        userNameLabel.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.layer.borderWidth = 0
        followButton.backgroundColor = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 3,
                                        y: 3,
                                        width: contentView.height-6,
                                        height: contentView.height-6)
        profileImageView.layer.cornerRadius = profileImageView.height/2.0
        
        let buttomWidth = contentView.widht > 500 ? 220 : contentView.widht/3
        followButton.frame = CGRect(x: contentView.widht-5-buttomWidth,
                                    y: (contentView.height-30)/2,
                                    width: buttomWidth,
                                    height: 30)
        
        let labelHeight = contentView.height/2
        nameLabel.frame = CGRect(x: profileImageView.right+5,
                                 y: 0,
                                 width: contentView.widht-8-profileImageView.widht,
                                 height: labelHeight)
        userNameLabel.frame = CGRect(x: profileImageView.right+5,
                                 y: nameLabel.bottom,
                                 width: contentView.widht-8-profileImageView.widht,
                                 height: labelHeight)
        
    }
    
}
