//
//  ViewController.swift
//  Instagram
//
//  Created by Hamza on 2/21/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit
import FirebaseAuth


struct HomeFeedRenderViewModel {
    let header : PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeVC: UIViewController {
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        // Register cells
        tableView.register(IGFeedPostCell.self, forCellReuseIdentifier: IGFeedPostCell.identifier)
        tableView.register(IGFeedPostHeaderCell.self, forCellReuseIdentifier: IGFeedPostHeaderCell.identifier)
        tableView.register(IGFeedPostActionsCell.self, forCellReuseIdentifier: IGFeedPostActionsCell.identifier)
        tableView.register(IGFeedPostGeneralCell.self, forCellReuseIdentifier: IGFeedPostGeneralCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        createMockModels()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func createMockModels() {
        let user = User(username: "@joe_abraham", bio: "", name: (first: "", last: ""),profilePhoto: URL(string: "https://www.shutterstock.com/image-vector/check-back-soon-hand-lettering-inscription-1379832464")!, birthDate: Date(), gender: .male, counts: UserCount( followers: 1, followings: 1, posts: 1), joinDate: Date() )
        let post = UserPost(identifier: "",
                            postType: .photo,
                            thumbnailImage: URL(string: "https://www.shutterstock.com/image-vector/check-back-soon-hand-lettering-inscription-1379832464")!,
                            postURL: URL(string: "https://www.shutterstock.com/image-vector/check-back-soon-hand-lettering-inscription-1379832464")!,
                            caption: nil,
                            likeCount: [], comments: [], createdDate: Date(), taggedUser: [],
                            owner: user)
        
        var comments = [PostComment]()
        for x in 0..<2 {
            comments.append(
                PostComment(identifier: "\(x)",
                    username: "@juan",
                    text: "Nice Pic",
                    createdDate: Date(),
                    likes: []))
        }
        
        for _ in 0..<5 {
            let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)),
                                                    post: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                                                    actions: PostRenderViewModel(renderType: .actions(provider: " ")),
                                                    comments: PostRenderViewModel(renderType: .comments(comments: comments)))
            
            feedRenderModels.append(viewModel)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        checkAuthentification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    private func checkAuthentification() {
        // Check auth status
        if Auth.auth().currentUser == nil {
            // Show Login
            let logVC = LoginVC()
            logVC.modalPresentationStyle = .fullScreen
            present(logVC, animated: false)
        }
    }

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        } else {
            let position = x % 4 == 0 ? x/4 : ((x - (x % 4)) / 4 )
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
            // Header
            return 1
        } else if subSection == 1 {
            // Post
            return 1
        } else if subSection == 2 {
            // Actions
            return 1
        } else if subSection == 3 {
            // Comments
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments): return comments.count > 2 ? 2 : comments.count
            case .header, .actions , .primaryContent: return 0
            }
        }
            return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = indexPath.section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        } else {
            let position = x % 4 == 0 ? x/4 : ((x - (x % 4)) / 4 )
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
            // Header
            switch model.header.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderCell.identifier, for: indexPath) as! IGFeedPostHeaderCell
                cell.configure(with: user)
                cell.delegate = self
                return cell
            case .comments, .actions, .primaryContent: return UITableViewCell()
            }
            
        } else if subSection == 1 {
            // Post
            switch model.post.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostCell.identifier, for: indexPath) as! IGFeedPostCell
                cell.configure(with: post)
                return cell
            case .comments, .actions , .header: return UITableViewCell()
            }
            
        } else if subSection == 2 {
            // Actions
            switch model.actions.renderType {
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsCell.identifier, for: indexPath) as! IGFeedPostActionsCell
                cell.delegate = self
                return cell
            case .comments, .header, .primaryContent: return UITableViewCell()
            }
            
        } else if subSection == 3 {
            // Comments
            switch model.comments.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralCell.identifier, for: indexPath) as! IGFeedPostGeneralCell
                return cell
            case .header, .actions, .primaryContent: return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 4
        if subSection == 0 {
            // Header
            return 50
        } else if subSection == 1 {
            // Post
            return tableView.width
        } else if subSection == 2 {
            // Actions (Like/Comm)
            return 60
        } else if subSection == 3 {
            // Comment row 
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
}

extension HomeVC: IGFeedPostHeaderCellDelegate {
    func moreButtonClicked() {
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { [weak self] _ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    func reportPost() {
        
    }
    
}

extension HomeVC: IGFeedPostActionsCellDelegate {
    func likeButtonClicked() {
        print("like")
    }
    
    func commentButtonClicked() {
        print("comment")
    }
    
    func sendButtonClicked() {
        print("send")
    }
    
    
}
