//
//  IGFeedPostActionsCell.swift
//  Instagram
//
//  Created by Hamza on 3/3/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit

protocol IGFeedPostActionsCellDelegate: AnyObject {
    func likeButtonClicked()
    func commentButtonClicked()
    func sendButtonClicked()
}

class IGFeedPostActionsCell: UITableViewCell {

    weak var delegate: IGFeedPostActionsCellDelegate?
    
    static let identifier = "IGFeedPostActionsCell"
    
    private let likeButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "like"), for: .normal)
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "comment"), for: .normal)
        return button
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "send"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(sendButton)
        
        likeButton.addTarget(self, action: #selector(likeButtonTap), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentButtonTap), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTap), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func likeButtonTap() {
        delegate?.likeButtonClicked()
    }
    
    @objc private func commentButtonTap() {
        delegate?.commentButtonClicked()
    }
    
    @objc private func sendButtonTap() {
        delegate?.sendButtonClicked()
    }
    
    public func configure(with post: UserPost){
        // configure the cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // like, comment, send
        let buttonSize = contentView.height-10
        
        let buttons = [likeButton, commentButton, sendButton]
        
        for x in 0..<buttons.count {
            let button = buttons[x]
            button.frame = CGRect(x: (CGFloat(x)*buttonSize) + (10*CGFloat(x+1)), y: 5, width: buttonSize, height: buttonSize)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
