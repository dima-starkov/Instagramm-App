//
//  ViewController.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 05.07.2021.
//

import UIKit
import FirebaseAuth

struct HomeFeedRenderViewModel {
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let action: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeViewController: UIViewController {
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
        let table = UITableView()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        createMockModels()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    private func createMockModels() {
        let user = User(userName: "Dima",
                        bio: " ",
                        name: (first: "", last: ""),
                        birthDate: Date(),
                        profilePhoto: URL(string: "https://www.google.com")!,
                        gender: .male,
                        counts: UserCount(followers: 10, following: 10, posts: 10), joinDate: Date())
        
        let post = UserPost(identifier: "",
                            postType: .photo,
                            thumbnailImage: URL(string: "https://www.google.com")!, postURL: URL(string: "https://www.google.com")!,
                            caption: "ss",
                            likeCount: [],
                            comments: [],
                            createdDate: Date(),
                            taggedUsers: [], owner: user)
        let comments = [PostComment(identifier: "", userName: "@dima", text: "Cool", createdDate: Date(), likes: [])]
        
        for x in 0..<5 {
            feedRenderModels.append(HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)),
                                                            post: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                                                            action: PostRenderViewModel(renderType: .actions(proveder: "")),
                                                            comments: PostRenderViewModel(renderType: .comments(comments: comments))))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
        
    }

    private func handleNotAuthenticated() {
        //Check Auth status
        if Auth.auth().currentUser == nil {
            //show log in
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
        }
    }
    
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        let model: HomeFeedRenderViewModel
        if x == 0 {
        model = feedRenderModels[0]
        } else {
        let position = x % 4 == 0 ? x/4 : ((x - (x % 4)) / 4)
        model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        switch subSection {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3:
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments): return comments.count > 2 ? 2: comments.count
            case .actions,.primaryContent,.header: return 0
            }
        default: fatalError()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = indexPath.section
        
        var model: HomeFeedRenderViewModel
        
        if x == 0 {
        model = feedRenderModels[0]
        } else {
        let position = x % 4 == 0 ? x/4 : ((x - (x % 4))/4)
        model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        switch subSection {
        case 0:
            let headerModel = model.header
            switch headerModel.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier,
                                                                    for: indexPath) as! IGFeedPostHeaderTableViewCell
                cell.configure(with: user)
                return cell
            case .actions,.primaryContent,.comments: return UITableViewCell()
            }
        case 1:
            let postModel = model.post
            switch postModel.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier,
                                                                    for: indexPath) as! IGFeedPostTableViewCell
                cell.configure(with: post)
                return cell
            case .actions,.header,.comments: return UITableViewCell()
            }
        case 2:
            let actionsModel = model.action
            switch actionsModel.renderType {
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier,
                                                                    for: indexPath) as! IGFeedPostActionsTableViewCell
            
                return cell
            case .header,.primaryContent,.comments: return UITableViewCell()
            }
        case 3:
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier,
                                                                    for: indexPath) as! IGFeedPostGeneralTableViewCell
            
                return cell
            case .actions,.primaryContent,.header: return UITableViewCell()
            }
        default: fatalError()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let subSection = indexPath.section % 4
        
        switch subSection {
        case 0: return 70
        case 1: return  tableView.widht
        case 2: return 60
        case 3: return 50
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       let subSection = section % 4
        return subSection == 3 ? 50 : 0
    }
}
