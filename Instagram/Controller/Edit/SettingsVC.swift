//
//  SettingsVC.swift
//  Instagram
//
//  Created by Hamza on 2/21/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import SafariServices
import UIKit

struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}


final class SettingsVC: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    private func configureModels() {
        data.append([ SettingCellModel(title: "Edit Profile", handler: { [weak self] in
            self?.editProfilClicked()
        }),
                      SettingCellModel(title: "Invite Friends", handler: { [weak self] in
                        self?.inviteFriendsClicked()
                      }),
                      SettingCellModel(title: "Save Original Posts", handler: { [weak self] in
                        self?.saveOriginalPostsClicked()
                      })
            ])
        
        data.append([ SettingCellModel(title: "Terms of services", handler: { [weak self] in
            self?.openURL(type: .terms)
        }),
                      SettingCellModel(title: "Privacy Policy", handler: { [weak self] in
                        self?.openURL(type: .privacy)
                      }),
                      SettingCellModel(title: "Help / Feedback", handler: { [weak self] in
                        self?.openURL(type: .help)
                      })
                      ])
        
        
        
            data.append([ SettingCellModel(title: "Log Out", handler: { [weak self] in
                self?.logOutClicked()
            })
                ])
    }
    
    enum SettingsURLType {
        case terms, privacy, help
    }
    
    private func openURL(type: SettingsURLType){
        let urlString: String
        
        switch type {
        case .terms: urlString = "https://help.instagram.com/581066165581870"
        case .privacy: urlString = "https://help.instagram.com/519522125107875/?maybe_redirect_pol=0"
        case .help: urlString = "https://help.instagram.com"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func saveOriginalPostsClicked(){
        
    }
    
    private func inviteFriendsClicked(){
        // Show share
    }
    
    private func editProfilClicked(){
        let vc = EditProfilVC()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func logOutClicked() {
        let actionSheet = UIAlertController(title: "Log Out",
                                            message: "Are you sure you want to Log Out?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut { (succes) in
                DispatchQueue.main.async {
                    if succes {
                        // present log In
                        let logVC = LoginVC()
                        logVC.modalPresentationStyle = .fullScreen
                        self.present(logVC, animated: true, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                            self.tabBarController?.selectedIndex = 0
                        })
                    } else {
                        // error occured
                        fatalError("Could not Log Out user")
                    }
                }
            }
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
    
}
