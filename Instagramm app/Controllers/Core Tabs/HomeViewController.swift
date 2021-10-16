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
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    
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
            @unknown default: fatalError("Invalid case")
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
        
        switch model.post.renderType {
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
        let model = feedRenderModels[indexPath.section]
        switch model.post.renderType {
        case .actions(_): return 60
        case .header(_): return 70
        case .primaryContent(_): return tableView.widht
        case .comments(_): return 50
        }
    }
}
