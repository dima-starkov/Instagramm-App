//
//  NotificationsViewController.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 05.07.2021.
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

final class NotificationsViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.isHidden = false
        table.register(NotificationLikeEventTableViewCell.self,
                       forCellReuseIdentifier:NotificationLikeEventTableViewCell.identifier )
        table.register(NotificationFollowEventTableViewCell.self,
                       forCellReuseIdentifier:NotificationFollowEventTableViewCell.identifier )
        
        return table
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    private var models = [UserNotification]()
    
    private lazy var noNotificationView = NoNotifivationsView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemBackground
        fetchNotification()
        tableView.delegate = self
        tableView.dataSource = self
       // spinner.startAnimating()
        view.addSubview(spinner)
        view.addSubview(tableView)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    private func fetchNotification() {
        for x in 0...100 {
            let post = UserPost(identifier: "",
                                postType: .photo,
                                thumbnailImage: URL(string: "https://www.google.com")!,
                                caption: "ss",
                                likeCount: [],
                                comments: [],
                                createdDate: Date(),
                                taggedUsers: [])
            
            let model = UserNotification(type: x % 2 == 0 ? .like(post: post ) : .follow(state: .not_following),
                                         text: "bla",
                                    user: User(userName: "Dima",
                                                    bio: " ",
                                                    name: (first: "", last: ""),
                                                    birthDate: Date(),
                                                    profilePhoto: URL(string: "https://www.google.com")!,
                                                    gender: .male,
                                                    counts: UserCount(followers: 10, following: 10, posts: 10), joinDate: Date()))
            models.append(model)
        }
    }
    
    private func addNoNotifivations() {
        tableView.isHidden = true
        view.addSubview(noNotificationView)
        noNotificationView.frame = CGRect(x: 0, y: 0, width: view.widht/2, height: view.widht/4)
        noNotificationView.center = view.center
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension NotificationsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type {
        case .follow:
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifier,for: indexPath) as! NotificationFollowEventTableViewCell
           // cell.configure(with: model)
            cell.delegate = self
            return cell
            
        case .like(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifier,for: indexPath) as! NotificationLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}

extension NotificationsViewController: NotificationLikeEventTableViewCellDelegate {
    func didTapRelatedPostButton(model: UserNotification) {
        switch model.type {
        case .like(let post):
            let vc = PostViewController(model: nil)
            vc.title = "Post"
        case .follow(_):
            fatalError("Should never get called")
        }
    }
}

extension NotificationsViewController: NotificationFollowEventTableViewCellDelegate {
    func didTapFollowUnFollowButton(model: UserNotification) {
       print("TapButton")
    }
}
