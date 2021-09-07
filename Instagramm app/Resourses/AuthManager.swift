//
//  AuthManager.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 05.07.2021.
//

import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    //MARK: - Public
    
    public func registerNewUser(userName: String, email: String, password: String,completion: @escaping (Bool)-> Void) {
        DataBaseManager.shared.canCreateNewUser(with: email, username: userName) { canCreate in
            if canCreate {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard result != nil, error == nil else {
                        completion(false)
                        return }
                    
                    //insert into database
                    DataBaseManager.shared.insertNewUser(with: email, userName: userName) { inserted in
                        if inserted {
                            completion(true)
                            return
                        } else {
                            completion(false)
                            return
                        }
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    ///Login User
    public func loginUser(userName: String?, email: String?, password: String, completion: @escaping (Bool)-> Void) {
        if let email = email {
            //email login
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                
                completion(true)
            }
        } else if let username = userName {
            //username login
            print(username)
        }
    }
    
    ///Log Out User
    public func logOut(completion: (Bool)-> Void) {
        do{
            try Auth.auth().signOut()
            completion(true)
            return
        } catch {
            completion(false)
            print("error Log Out")
            return
        }
    }
    
}
