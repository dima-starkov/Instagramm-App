//
//  IGFeedPostTableViewCell.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 14.07.2021.
//

import UIKit

final class IGFeedPostTableViewCell: UITableViewCell {
    
    static let identifier = "IGFeedPostTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        //configure cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
