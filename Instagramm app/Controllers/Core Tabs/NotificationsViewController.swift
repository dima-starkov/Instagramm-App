//
//  NotificationsViewController.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 05.07.2021.
//

import UIKit

class NotificationsViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.isHidden = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    private lazy var noNotificationView = NoNotifivationsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemBackground
        
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
    
    private func layoutNoNotifivations() {
        tableView.isHidden = true
        view.addSubview(noNotificationView)
        noNotificationView.frame = CGRect(x: 0, y: 0, width: view.widht/2, height: view.widht/4)
        noNotificationView.center = view.center
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension NotificationsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        
        return cell
    }
    
}
