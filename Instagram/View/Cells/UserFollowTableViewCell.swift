//
//  UserFollowTableViewCell.swift
//  Instagram
//
//  Created by Hamza on 3/25/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit

protocol UserFollowTableViewCellDelegate: AnyObject {
    func followUnfollowBtnClicked(model: UserRelationship)
}

enum FollowState {
    case following // indicates the current user is following the other user
    case not_following // indicates the current user is Not following the other user 
}

struct UserRelationship {
    let username: String
    let name: String
    let type: FollowState
}

class UserFollowTableViewCell: UITableViewCell {
    static let identifier = "UserFollowTableViewCell"
    weak var delegate: UserFollowTableViewCellDelegate?
    private var model: UserRelationship?
    
    private let profileImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        imageView.contentMode = .scaleAspectFill
       return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = "Ramsdel"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Oryadabal"
        return label
    }()
    
    private let followBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(followBtn)
        contentView.addSubview(profileImgView)
        selectionStyle = .none
        followBtn.addTarget(self,
                            action: #selector(followBtnClicked),
                            for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func followBtnClicked() {
        guard let model = model else {
            return
        }
        delegate?.followUnfollowBtnClicked(model: model)
    }

    public func configure(with model: UserRelationship) {
        self.model = model
        nameLabel.text = model.name
        usernameLabel.text = model.username
        
        switch model.type {
        case .following:
            // Show unfolow Button
            followBtn.setTitle("Unfollow", for: .normal)
            followBtn.layer.borderWidth = 1
            followBtn.backgroundColor = .white
            followBtn.layer.borderColor = UIColor.black.cgColor
            followBtn.setTitleColor(.black, for: .normal)
            
        case .not_following:
            // Show follow Button
            followBtn.setTitle("Follow", for: .normal)
            followBtn.setTitleColor(.white, for: .normal)
            followBtn.layer.borderWidth = 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImgView.image = nil
        nameLabel.text = nil
        usernameLabel.text = nil
        followBtn.setTitle(nil, for: .normal)
        followBtn.layer.borderWidth = 0
        followBtn.backgroundColor = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImgView.frame = CGRect(x: 3,
                                      y: 3,
                                      width: contentView.height - 6,
                                      height: contentView.height - 6)
        profileImgView.layer.cornerRadius = profileImgView.height / 2.0
        
        let buttonWidth = contentView.width > 500 ? 220.0 : contentView.width/3
        followBtn.frame = CGRect(x: contentView.width-5-buttonWidth,
                                 y: (contentView.height-40)/2,
                                 width: buttonWidth,
                                 height: 40)
        
        let labelHeight = contentView.height / 2
        nameLabel.frame = CGRect(x: profileImgView.right + 5,
                                 y: 0,
                                 width: contentView.width-3-profileImgView.width-buttonWidth,
                                 height: labelHeight)
        usernameLabel.frame = CGRect(x: profileImgView.right + 5,
                                 y: nameLabel.bottom,
                                 width: contentView.width-3-profileImgView.width-buttonWidth,
                                 height: labelHeight)
        
    }
    
}
