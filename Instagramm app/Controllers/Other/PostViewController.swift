//
//  PostViewController.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 05.07.2021.
//

import UIKit

/*
 Section
 -Header model
 Section
 -Post cell model
 Section
 -Action buttons cell model
 Section
 -n number of general models for comments
 */

enum PostRenderType {
    case header(provider: User)
    case primaryContent(provider: UserPost) //post
    case actions(proveder: String) //like,comment,share
    case comments(comments: [PostComment])
}
//Model of render Post
struct PostRenderViewModel {
    let renderType: PostRenderType
}

class PostViewController: UIViewController {
    
    private let model: UserPost?
    
    private var renderModels = [PostRenderViewModel]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        //register cells
        table.register(IGFeedPostTableViewCell.self,
                       forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        table.register(IGFeedPostHeaderTableViewCell.self,
                       forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        table.register(IGFeedPostActionsTableViewCell.self,
                       forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        table.register(IGFeedPostGeneralTableViewCell.self,
                       forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        
        return table
    }()
    
    // MARK: - Init
    
    init(model: UserPost?) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        guard let userPostModel = self.model else { return }
        
        //header
        renderModels.append(PostRenderViewModel(renderType: .header(provider: userPostModel.owner)))
        //Post
        renderModels.append(PostRenderViewModel(renderType: .primaryContent(provider: userPostModel)))
        //Actions
        renderModels.append(PostRenderViewModel(renderType: .actions(proveder: " ")))
        //4 Comments
        
        var comments = [PostComment]()
        for x in 0 ..< 4 {
            comments.append(PostComment(identifier: "123_\(x)" ,userName: "@joe", text: "Good amazing", createdDate: Date(), likes:[]))
        }
        renderModels.append(PostRenderViewModel(renderType: .comments(comments: comments)))
    }

}

extension PostViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModels[section].renderType {
        case .actions(_): return 1
        case .header(_): return 1
        case .primaryContent(_): return 1
        case .comments(let comments): return comments.count > 4 ? 4 : comments.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderModels[indexPath.section]
        switch model.renderType {
        case .actions(let actions):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier,
                                                     for: indexPath) as! IGFeedPostActionsTableViewCell
        
            return cell
            
        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier,
                                                     for: indexPath) as! IGFeedPostHeaderTableViewCell
      
            return cell
            
        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier,
                                                     for: indexPath) as! IGFeedPostTableViewCell
           
            return cell
            
        case .comments(let comments):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier,
                                                     for: indexPath) as! IGFeedPostGeneralTableViewCell
      
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModels[indexPath.section]
        switch model.renderType {
        case .actions(_): return 60
        case .header(_): return 70
        case .primaryContent(_): return tableView.widht
        case .comments(_): return 50
        }
    }
}
