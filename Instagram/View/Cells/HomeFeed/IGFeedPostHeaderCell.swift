//
//  IGFeedPostHeaderCell.swift
//  Instagram
//
//  Created by Hamza on 3/3/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit

protocol IGFeedPostHeaderCellDelegate: AnyObject {
    func moreButtonClicked()
}

class IGFeedPostHeaderCell: UITableViewCell {
    
    weak var delegate: IGFeedPostHeaderCellDelegate?

    static let identifier = "IGFeedPostHeaderCell"
    
    private let profilePhotoImgView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let usernameLbl: UILabel = {
        let label = UILabel()
 //       label.textColor = .black
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let moreButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "ellipsis"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profilePhotoImgView)
        contentView.addSubview(usernameLbl)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self,
                             action: #selector(buttonClicked),
                             for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonClicked() {
        delegate?.moreButtonClicked()
    }
    
    public func configure(with model: User){
        usernameLbl.text = model.username
        profilePhotoImgView.image = UIImage(named: "contacts")
 //       profilePhotoImgView.downloaded(from: model.profilePhoto)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.height-4
        profilePhotoImgView.frame = CGRect(x: 2, y: 2, width: size, height: size)
        profilePhotoImgView.layer.cornerRadius = size/2
        
        moreButton.frame = CGRect(x: contentView.width-size, y: 0, width: size, height: size)
        
        usernameLbl.frame = CGRect(x: profilePhotoImgView.right+10,
                                   y: 2,
                                   width: contentView.width-(size*2)-15,
                                   height: contentView.height-4)
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLbl.text = nil
        profilePhotoImgView.image = nil
    }
}
