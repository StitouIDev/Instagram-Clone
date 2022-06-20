//
//  NotificationFollowEventCell.swift
//  Instagram
//
//  Created by Hamza on 3/30/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit

protocol NotificationFollowEventCellDelegate: AnyObject {
    func followUnfollowBtnClicked(model: UserNotification)
}

class NotificationFollowEventCell: UITableViewCell {
    static let identifier = "NotificationFollowEventCell"
   
    weak var delegate: NotificationFollowEventCellDelegate?
    
    private var model: UserNotification?
    
    private let profileImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.numberOfLines = 0
        label.text = "@james followed you"
        return label
    }()
    
    private let followBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImgView)
        contentView.addSubview(label)
        contentView.addSubview(followBtn)
        followBtn.addTarget(self,
                            action: #selector(followBtnClicked),
                            for: .touchUpInside)
        configureForFollow()
        selectionStyle = .none
        
    }
    
    @objc private func followBtnClicked() {
        guard let model = model else {
            return
        }
        
        delegate?.followUnfollowBtnClicked(model: model)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserNotification) {
        self.model = model
        switch model.type {
        case .like(_):
            break
        case .follow(let state):
            // configure Button
            switch state {
            case .following:
                // show unfollow Button
                configureForFollow()
            case .not_following:
                // show follow Button
                followBtn.setTitle("Follow", for: .normal)
                followBtn.setTitleColor(.white, for: .normal)
                followBtn.layer.borderWidth = 0
            }
        }
        
        label.text = model.text
        profileImgView.downloaded(from: model.user.profilePhoto)
    }
    
    private func configureForFollow() {
        followBtn.setTitle("Unfollow", for: .normal)
        followBtn.setTitleColor(.black, for: .normal)
        followBtn.layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        followBtn.setTitle(nil, for: .normal)
        followBtn.backgroundColor = nil
        followBtn.layer.borderWidth = 0
        label.text = nil
        imageView?.image = nil
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // photo, text, post button
        profileImgView.frame = CGRect(x: 3, y: 3, width: contentView.height - 6, height: contentView.height - 6)
        profileImgView.layer.cornerRadius = profileImgView.height/2
        
        let size: CGFloat = 100
        let buttonHeight: CGFloat = 40
        followBtn.frame = CGRect(x: contentView.width-5-size,
                                 y: (contentView.height-buttonHeight)/2,
                                 width: size,
                                 height: buttonHeight)
     //   followBtn.backgroundColor = .orange
        label.frame = CGRect(x: profileImgView.right+5,
                             y: 0,
                             width: contentView.width-size-profileImgView.width-16,
                             height: contentView.height)
    }
    
}
