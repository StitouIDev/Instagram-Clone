//
//  PostVC.swift
//  Instagram
//
//  Created by Hamza on 2/21/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit



/*
 
 Section
 - Header model
 Section
 - Post Cell model
 Section
 - Actions Buttons Cell model
 Section
 - n Number of general models for comments
 
 */

/// States of a rendered cell
enum PostRenderType {
    case header(provider: User)
    case primaryContent(provider: UserPost) // Post
    case actions(provider: String) // like, comment, share
    case comments(comments: [PostComment])
}

/// Model of renderd Post
struct PostRenderViewModel {
    let renderType: PostRenderType
}

class PostVC: UIViewController {
    
    private let model: UserPost?
    private var renderModels = [PostRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        // Register cells
        tableView.register(IGFeedPostCell.self, forCellReuseIdentifier: IGFeedPostCell.identifier)
        tableView.register(IGFeedPostHeaderCell.self, forCellReuseIdentifier: IGFeedPostHeaderCell.identifier)
        tableView.register(IGFeedPostActionsCell.self, forCellReuseIdentifier: IGFeedPostActionsCell.identifier)
        tableView.register(IGFeedPostGeneralCell.self, forCellReuseIdentifier: IGFeedPostGeneralCell.identifier)
        return tableView
    }()
    
    // MARK: - Init
    
    init(model: UserPost?) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureModels() {
        guard let userPostModel = self.model else {
            return
        }
        
        // Header
        renderModels.append(PostRenderViewModel(renderType: .header(provider: userPostModel.owner)))
        
        // Post
        renderModels.append(PostRenderViewModel(renderType: .primaryContent(provider: userPostModel)))
        // ACations
        renderModels.append(PostRenderViewModel(renderType: .actions(provider: "")))
        
        // 4 Commments
        var comments = [PostComment]()
        for x in 0..<4 {
            comments.append(
                PostComment(identifier: "123_\(x)",
                    username: "@Omni",
                    text: "Nice One",
                    createdDate: Date(),
                    likes: []
                )
            )
        }
        renderModels.append(PostRenderViewModel(renderType: .comments(comments: comments)))
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension PostVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModels[section].renderType {
        case .header(_): return 1
        case .primaryContent(_): return 1
        case .actions(_): return 1
        case .comments(let comments): return comments.count > 4 ? 4 : comments.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderModels[indexPath.section]
        
        switch model.renderType {
        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderCell.identifier, for: indexPath) as! IGFeedPostHeaderCell
            return cell
        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostCell.identifier, for: indexPath) as! IGFeedPostCell
            return cell
        case .actions(let actions):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsCell.identifier, for: indexPath) as! IGFeedPostActionsCell
            return cell
            
        case .comments(let comments):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralCell.identifier, for: indexPath) as! IGFeedPostGeneralCell
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModels[indexPath.section]
        
        switch model.renderType  {
        case .header(_): return 60
        case .primaryContent(_): return tableView.width
        case .actions(_): return 60
        case .comments(_): return 50
            
        }
    }
    
}
