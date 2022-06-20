//
//  ProfileTabsCollectionReusableView.swift
//  Instagram
//
//  Created by Hamza on 3/17/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit

protocol ProfileTabsCollectionReusableViewDelegate: AnyObject {
    func profilTabsGridBtnClicked()
    func profilTabstaggedBtnClicked()
    
}


class ProfileTabsCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileTabsCollectionReusableView"
    public weak var delegate: ProfileTabsCollectionReusableViewDelegate?
    
    struct Constants  {
        static let padding: CGFloat = 8
    }

    private let gridBtn: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .blue
        button.setBackgroundImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    
    private let taggedBtn: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .lightGray
        button.setBackgroundImage(UIImage(named: "tag"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
 //       backgroundColor = .white
        addSubview(gridBtn)
        addSubview(taggedBtn)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = height - (Constants.padding * 2)
        let grinBtnX = ((width/2) - size)/2
        gridBtn.frame = CGRect(x: grinBtnX,
                               y: Constants.padding,
                               width: size,
                               height: size)
        
        taggedBtn.frame = CGRect(x: grinBtnX + (width/2),
                               y: Constants.padding,
                               width: size,
                               height: size)
        
    }
    
    private func addBtnAction() {
        gridBtn.addTarget(self, action: #selector(gridBtnClicked), for: .touchUpInside)
        taggedBtn.addTarget(self, action: #selector(taggedBtnClicked), for: .touchUpInside)
    }
   
    
    // - MARk: Actions
    
    @objc private func gridBtnClicked() {
        gridBtn.tintColor = .blue
        taggedBtn.tintColor = .lightGray
        delegate?.profilTabsGridBtnClicked()
    }
    
    @objc private func taggedBtnClicked() {
        gridBtn.tintColor = .lightGray
        taggedBtn.tintColor = .blue
        delegate?.profilTabstaggedBtnClicked()
    }
    
    
}
