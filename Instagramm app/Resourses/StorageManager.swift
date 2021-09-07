//
//  StorageManager.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 05.07.2021.
//

import FirebaseStorage

public class StorageManager {
    static let shared = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
   public enum IGStorageManagerError: Error {
        case FailedToDownload
    }
    
    // MARK: - Public
    
    public func uploadUserPhotoPost(model: UserPost,completion: @escaping (Result<URL,Error>)-> Void){
        
    }
    
    public func downloadImage(with reference: String ,completion: @escaping (Result<URL,IGStorageManagerError>)-> Void) {
        bucket.child(reference).downloadURL(completion: {url, error in
            guard let url = url ,error == nil else {
                completion(.failure(.FailedToDownload))
                return}
            
            completion(.success(url))
        })
    }
}

