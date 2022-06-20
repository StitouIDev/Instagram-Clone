//
//  EditProfilVC.swift
//  Instagram
//
//  Created by Hamza on 2/21/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit

struct EditProfileFormModel {
    let label: String
    let placeholder: String
    var value: String?
}

final class EditProfilVC: UIViewController, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FormsTableViewCell.self, forCellReuseIdentifier: FormsTableViewCell.identifier)
        return tableView
    }()

    private var models = [[EditProfileFormModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        tableView.tableHeaderView = createTableHeaderView()
        tableView.dataSource = self
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(saveClicked))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(cancelClicked))
    }
    
    private func configureModels() {
        // name, username, website, bio
        let section1Labels = ["Name", "Username", "Bio"]
        var section1 = [EditProfileFormModel]()
        for label in section1Labels {
            let model = EditProfileFormModel(label: label, placeholder: "Entre \(label) ....", value: nil)
            section1.append(model)
        }
        models.append(section1)
        
        // email, phone, gender
        
        let section2Labels = ["Email", "Phome", "Gender"]
        var section2 = [EditProfileFormModel]()
        for label in section2Labels {
            let model = EditProfileFormModel(label: label, placeholder: "Entre \(label) ....", value: nil)
            section2.append(model)
        }
        models.append(section2)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    // MARK: - TableView
    
    private func createTableHeaderView() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/4).integral)
        let size = header.height/1.5
        let profilePhotoBtn = UIButton(frame: CGRect(x: (view.width-size)/2, y: (header.height-size)/2, width: size, height: size))
        header.addSubview(profilePhotoBtn)
        profilePhotoBtn.layer.masksToBounds = true
        profilePhotoBtn.layer.cornerRadius = size/2.0
        profilePhotoBtn.tintColor = .white
        profilePhotoBtn.addTarget(self, action: #selector(profilePhotoBtnClicked), for: .touchUpInside)
        profilePhotoBtn.setBackgroundImage(UIImage(named: "contacts"), for: .normal)
        profilePhotoBtn.layer.borderWidth = 1
        return header
    }
    
    @objc private func profilePhotoBtnClicked() {
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: FormsTableViewCell.identifier, for: indexPath) as! FormsTableViewCell
        cell.configure(with: model)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "Private Information"
    }
    
    
    // MARK: - Action
    
    @objc private func saveClicked() {
     // Save
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func changeProfilPicture() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "Change profile picture",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                                                
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        
        
        present(actionSheet, animated: true)
    }
}


extension EditProfilVC: FormsTableViewCellDelegate {
    func formTableViewCell(_ cell: UITableViewCell, didUpdateField updatedModel: EditProfileFormModel) {
        // Update the model
        
        
    }
    
    
}
