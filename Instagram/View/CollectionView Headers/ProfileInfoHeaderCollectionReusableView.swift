//
//  ProfileInfoHeaderCollectionReusableView.swift
//  Instagram
//
//  Created by Hamza on 3/17/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit


protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderPostsBtnClicked(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderFollowersBtnClicked(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderFollowingBtnClicked(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderEditProfileBtnClicked(_ header: ProfileInfoHeaderCollectionReusableView)
}


final class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    public weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
    private let profilePhotoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let postsBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Posts", for: .normal)
        button.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        return button
    }()
    
    private let followingBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Following", for: .normal)
        button.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        return button
    }()
    
    private let followersBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Followers", for: .normal)
        button.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        return button
    }()
    
    private let editProfileBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Your Profile", for: .normal)
        button.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ramsdal oryadabal"
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "This is the first Account!"
        label.textColor = .white
        label.numberOfLines = 0 // line wrap
        
        return label
    }()
    
    
    // MARK: -init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addButtonActions()
 //       backgroundColor = .white
        clipsToBounds = true
    }
    
    private func addSubviews() {
        addSubview(profilePhotoImageView)
        addSubview(postsBtn)
        addSubview(followingBtn)
        addSubview(followersBtn)
        addSubview(editProfileBtn)
        addSubview(nameLabel)
        addSubview(bioLabel)
    }
    
    private func addButtonActions() {
        followersBtn.addTarget(self,
                               action: #selector(followersBtnClicked),
                               for: .touchUpInside)
        followingBtn.addTarget(self,
                               action: #selector(followingBtnClicked),
                               for: .touchUpInside)
        postsBtn.addTarget(self,
                               action: #selector(postsBtnClicked),
                               for: .touchUpInside)
        editProfileBtn.addTarget(self,
                               action: #selector(editProfileBtnClicked),
                               for: .touchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let profilePhotoSize = width/4
        profilePhotoImageView.frame = CGRect(
            x: 5,
            y: 5,
            width: profilePhotoSize,
            height: profilePhotoSize).integral
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize/2.0
        
        let buttonHeight = profilePhotoSize/2
        let countButtonWidth = (width-10-profilePhotoSize)/3
        
        postsBtn.frame = CGRect(
            x: profilePhotoImageView.right,
            y: 5,
            width: countButtonWidth,
            height: buttonHeight).integral
        
        followersBtn.frame = CGRect(
            x: postsBtn.right,
            y: 5,
            width: countButtonWidth,
            height: buttonHeight).integral
        
        followingBtn.frame = CGRect(
                x: followersBtn.right,
                y: 5,
                width: countButtonWidth,
                height: buttonHeight).integral
        
        
        editProfileBtn.frame = CGRect(
            x: profilePhotoImageView.right,
            y: 5 + buttonHeight,
            width: countButtonWidth * 3,
            height: buttonHeight).integral
        
        nameLabel.frame = CGRect(
            x: 5,
            y: 5 + profilePhotoImageView.bottom,
            width: width-10,
            height: 50).integral
        
        let bioLabelSize = bioLabel.sizeThatFits(frame.size)
        bioLabel.frame = CGRect(
            x: 5,
            y: 5 + nameLabel.bottom,
            width: width-10,
            height: bioLabelSize.height).integral
        
    }
    
    // MARK: - Actions
    
    @objc private func followersBtnClicked() {
        delegate?.profileHeaderFollowersBtnClicked(self)
    }
    
    @objc private func followingBtnClicked() {
        delegate?.profileHeaderFollowingBtnClicked(self)
    }
    
    @objc private func postsBtnClicked() {
        delegate?.profileHeaderPostsBtnClicked(self)
    }
    
    @objc private func editProfileBtnClicked() {
        delegate?.profileHeaderEditProfileBtnClicked(self)
    }
}
