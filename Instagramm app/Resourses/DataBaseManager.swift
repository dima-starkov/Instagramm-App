//
//  DataBaseManager.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 05.07.2021.
//

import FirebaseDatabase

public class DataBaseManager {
    
    static let shared = DataBaseManager()
    private let database = Database.database().reference()
    
    //MARK: - Public
    
    public func canCreateNewUser(with email: String, username: String, completion: (Bool)-> Void){
        completion(true)
    }
    
    public func insertNewUser(with email: String,userName: String,completion: @escaping (Bool)-> Void) {
        database.child(email.safeDataBaseKey()).setValue(["username": userName]) { error, _ in
            if error == nil {
                //success
                completion(true)
                return
            } else {
                //failed
                completion(false)
                return
            }
        }
    }
    
  
}
