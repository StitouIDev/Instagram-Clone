//
//  NotificationsVC.swift
//  Instagram
//
//  Created by Hamza on 2/21/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit

enum UserNotificationType {
    case like(post: UserPost)
    case follow(state: FollowState)
}

struct UserNotification {
    let type: UserNotificationType
    let text: String
    let user: User
    
}

final class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView = {
       let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationLikeEventCell.self, forCellReuseIdentifier: NotificationLikeEventCell.identifier)
        tableView.register(NotificationFollowEventCell.self, forCellReuseIdentifier: NotificationFollowEventCell.identifier)
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private lazy var noNotificationsView = NoNotificationsView()
    
    private var models = [UserNotification]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        navigationItem.title = "Notifications"
        view.backgroundColor = .white
        view.addSubview(spinner)
 //       spinner.startAnimating()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    private func fetchNotifications() {
        for x in 0...100 {
            let user = User(username: "joe", bio: "", name: (first: "", last: ""),profilePhoto: URL(string: "https://www.shutterstock.com/image-vector/check-back-soon-hand-lettering-inscription-1379832464")!, birthDate: Date(), gender: .male, counts: UserCount( followers: 1, followings: 1, posts: 1), joinDate: Date() )
            let post = UserPost(identifier: "",
                                postType: .photo,
                                thumbnailImage: URL(string: "https://www.shutterstock.com/image-vector/check-back-soon-hand-lettering-inscription-1379832464")!,
                                postURL: URL(string: "https://www.shutterstock.com/image-vector/check-back-soon-hand-lettering-inscription-1379832464")!,
                                caption: nil,
                                likeCount: [], comments: [], createdDate: Date(), taggedUser: [],
                                owner: user)
            
            let model = UserNotification(type: x % 2 == 0 ? .like(post: post) : .follow(state: .not_following),
                                         text: "Hello World", user: user)
          models.append(model)
        }
    }
    
    private func layoutNoNotifications() {
        tableView.isHidden = true
        view.addSubview(noNotificationsView)
        noNotificationsView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/4)
        noNotificationsView.center = view.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type {
        case .like(_):
            // like cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventCell.identifier,
                                                     for: indexPath) as! NotificationLikeEventCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        case .follow:
            // follow cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventCell.identifier,
                                                     for: indexPath) as! NotificationFollowEventCell
  //         cell.configure(with: model)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension NotificationsVC: NotificationLikeEventCellDelegate {
    func relatedPostBtnClicked(model: UserNotification) {
        switch model.type {
        case .like(let post):
            let vc = PostVC(model: post)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .follow(_):
            fatalError("Dev Issue: Should never get called")
        }
    }
}

extension NotificationsVC: NotificationFollowEventCellDelegate {
    func followUnfollowBtnClicked(model: UserNotification) {
        print("Tapped Button")
        // perform database update
    }
    
    
}
