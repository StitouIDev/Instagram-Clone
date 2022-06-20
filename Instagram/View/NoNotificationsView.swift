//
//  NoNotificationsView.swift
//  Instagram
//
//  Created by Hamza on 3/29/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit

class NoNotificationsView: UIView {

    
    private let label: UILabel = {
       let label = UILabel()
        label.text = "No Notifications Yet"
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "bell")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: (width-50)/2, y: 0, width: 50, height: 50).integral
        label.frame = CGRect(x: 0, y: imageView.bottom, width: width, height: height-50).integral
    }
}
