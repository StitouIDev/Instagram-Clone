//
//  FormsTableViewCell.swift
//  Instagram
//
//  Created by Hamza on 3/15/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit

protocol FormsTableViewCellDelegate: AnyObject {
    func formTableViewCell(_ cell: UITableViewCell, didUpdateField updatedModel: EditProfileFormModel)
}

class FormsTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "FormTableViewCell"
    private var model: EditProfileFormModel?
    
    public weak var delegate: FormsTableViewCellDelegate?
    
    private let formLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private let field: UITextField = {
       let field = UITextField()
        field.returnKeyType = .done
        return field
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(formLabel)
        contentView.addSubview(field)
        field.delegate = self
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model:EditProfileFormModel) {
        self.model = model
        formLabel.text = model.label
        field.placeholder = model.placeholder
        field.text = model.value
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        formLabel.text = nil
        field.placeholder = nil
        field.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Assign frames
        formLabel.frame = CGRect(x: 5,
                                 y: 0,
                                 width: contentView.width/3,
                                 height: contentView.height)
        
        field.frame = CGRect(x: formLabel.right + 5,
                             y: 0,
                             width: contentView.width - 10 - formLabel.width,
                             height: contentView.height)
        
    }
    
    // Mark: - Field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = model else {
            return true
        }
        delegate?.formTableViewCell(self, didUpdateField: model)
        textField.resignFirstResponder()
        return true
    }
}
