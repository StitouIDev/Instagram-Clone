//
//  IGFeedPostGeneralCell.swift
//  Instagram
//
//  Created by Hamza on 3/3/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit


/// Comments
class IGFeedPostGeneralCell: UITableViewCell {

    static let identifier = "IGFeedPostGeneralCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(){
        // configure the cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
 
}
