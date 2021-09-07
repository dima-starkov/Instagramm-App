//
//  ViewController.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 05.07.2021.
//

import UIKit
import FirebaseAuth


class HomeViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier,for: indexPath) as! IGFeedPostTableViewCell
        
        return cell
    }
}
