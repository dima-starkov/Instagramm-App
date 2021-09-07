//
//  SettingViewController.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 05.07.2021.
//

import SafariServices
import UIKit

struct SettingCellModel {
    let title: String
    let handler: (()-> Void)
}



///View controller to show user settings
final class SettingViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private var data = [[SettingCellModel]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        data.append([
            SettingCellModel(title: "Edit Profile", handler: { [weak self] in
                self?.didTapEditProfile()
            }),
            SettingCellModel(title: "Invite Friends", handler: { [weak self] in
                self?.didTapInviteFriends()
            }),
            SettingCellModel(title: "Save Original Posts", handler: { [weak self] in
                self?.didTapSaveOriginaPost()
            })
        ])
        
        data.append([
            SettingCellModel(title: "Terms of Service", handler: { [weak self] in
                self?.openURl(type: .terms)
            }),
            SettingCellModel(title: "Privacy Policy", handler: { [weak self] in
                self?.openURl(type: .privacy)
            }),
            SettingCellModel(title: "Help & FeedBack", handler: { [weak self] in
                self?.openURl(type: .help)
            })
        ])
        
        data.append([
            SettingCellModel(title: "Log Out", handler: { [weak self] in
                self?.didTapLogOut()
            })
        ])
    }
    
    enum SettingsURLType {
        case terms,privacy,help
    }
    
    private func openURl(type: SettingsURLType) {
        let urlString: String
        
        switch type {
        case .terms: urlString = "https://www.instagram.com/about/legal/terms/before-january-19-2013/"
        case .privacy: urlString = "https://help.instagram.com/519522125107875"
        case .help: urlString = "https://help.instagram.com"
        }
        
        guard let url = URL(string: urlString) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    private func didTapSaveOriginaPost() {
        
    }
    
    private func didTapInviteFriends() {
        // Show share sheet to invite friends
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "Log Out", message: "Are You Sure?", preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut { success in
                DispatchQueue.main.async {
                    if success {
                        //good
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true, completion: {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        })
                        
                    } else {
                        //error
                        print("error log out")
                    }
                }
            }
        }))
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
    
}
