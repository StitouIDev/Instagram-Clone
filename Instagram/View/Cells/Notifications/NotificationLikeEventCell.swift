//
//  NotificationLikeEventCell.swift
//  Instagram
//
//  Created by Hamza on 3/30/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit

protocol NotificationLikeEventCellDelegate: AnyObject {
    func relatedPostBtnClicked(model: UserNotification)
}

class NotificationLikeEventCell: UITableViewCell {
    static let identifier = "NotificationLikeEventCell"
    weak var delegate: NotificationLikeEventCellDelegate?
    
    private var model: UserNotification?
    
    private let profileImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "test")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.numberOfLines = 0
        label.text = "@red Like your Photo"
        return label
    }()
    
    private let postBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImgView)
        contentView.addSubview(label)
        contentView.addSubview(postBtn)
        postBtn.addTarget(self,
                          action: #selector(postBtnClicked),
                          for: .touchUpInside)
        
        selectionStyle = .none
    }
    
    @objc private func postBtnClicked() {
        guard let model = model else {
            return
        }
        delegate?.relatedPostBtnClicked(model: model)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserNotification) {
        self.model = model
        switch model.type {
        case .like(let post):
            let thumbnail = post.thumbnailImage
            _ = URLSession.shared.dataTask(with: thumbnail) { (data, _ , _ ) in
                self.postBtn.setBackgroundImage(UIImage(data: data!), for: .normal)
            }
        case .follow:
            break
        }
        
        label.text = model.text
        profileImgView.downloaded(from: model.user.profilePhoto)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postBtn.backgroundColor = nil
        label.text = nil
        imageView?.image = nil
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        // photo, text, post button
        profileImgView.frame = CGRect(x: 3, y: 3, width: contentView.height - 6, height: contentView.height - 6)
        profileImgView.layer.cornerRadius = profileImgView.height/2
        
        let size = contentView.height-4
        postBtn.frame = CGRect(x: contentView.width-5-size, y: 2, width: size, height: size)
        
        label.frame = CGRect(x: profileImgView.right+5,
                             y: 0,
                             width: contentView.width-size-profileImgView.width-16,
                             height: contentView.height)
    }
    
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
