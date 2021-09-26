//
//  NotificationLikeEventTableViewCell.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 22.09.2021.
//

import UIKit
import SDWebImage

protocol NotificationLikeEventTableViewCellDelegate: AnyObject {
    func didTapRelatedPostButton(model:String)
}

class NotificationLikeEventTableViewCell: UITableViewCell {
    
    static let identifier = "NotificationFollowLikeTableViewCell"
    
    weak var delegate: NotificationLikeEventTableViewCellDelegate?
    
    private var model: UserNotification?
    
    private let profileImageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "test")
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "@dima_starkov like your photo"
        return label
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(label)
        contentView.addSubview(postButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserNotification){
        self.model = model
        switch model.type {
        case .like(let post):
            let thumbnail = post.thumbnailImage
            postButton.sd_setBackgroundImage(with: thumbnail, for: .normal, completed: nil)
        case .follow: break
        }
        label.text = model.text
        profileImageView.sd_setImage(with: model.user.profilePhoto)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postButton.setBackgroundImage(nil, for: .normal)
        label.text = nil
        profileImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height - 6, height: contentView.height - 6 )
        profileImageView.layer.cornerRadius = profileImageView.height/2
        
        let size = contentView.height - 4
        postButton.frame  = CGRect(x: contentView.widht-size, y: 2, width: size, height: size)
        
        label.frame = CGRect(x: profileImageView.right,
                             y: 0,
                             width: contentView.widht-size-profileImageView.widht-6,
                             height: contentView.height)
    }
}

