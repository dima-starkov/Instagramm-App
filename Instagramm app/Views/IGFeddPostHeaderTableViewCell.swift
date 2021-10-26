//
//  IGFeddPostHeaderTableViewCell.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 14.07.2021.
//

import UIKit
import SDWebImage

class IGFeedPostHeaderTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostHeaderTableViewCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(photoImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(moreButton)
        
        moreButton.addTarget(self,
                             action: #selector(didTapMore),
                             for: .touchUpInside)
    }
    
    @objc private func didTapMore() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: User) {
        userNameLabel.text = model.userName
        photoImageView.image = UIImage(systemName: "person.circle")
      //  photoImageView.sd_setImage(with: model.profilePhoto, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.height - 4
        photoImageView.frame = CGRect(x: 2, y: 2, width: size, height: size)
        photoImageView.layer.cornerRadius = size/2
        
        moreButton.frame = CGRect(x: contentView.widht - size - 2,
                                  y: 2,
                                  width: size,
                                  height: size)
        
        userNameLabel.frame = CGRect(x: photoImageView.right + 10,
                                     y: 2,
                                     width: contentView.widht - (size*2),
                                     height: contentView.height - 4)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = nil
        photoImageView.image = nil
    }

}
