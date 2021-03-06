//
//  Models.swift
//  Instagramm app
//
//  Created by Дмитрий Старков on 22.08.2021.
//

import Foundation

enum Gender {
    case male,female, other
}

struct User {
    let userName: String
    let bio: String
    let name: (first: String, last: String)
    let birthDate: Date
    let profilePhoto: URL
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}

public enum UserPostType: String {
    case photo = "Photo"
    case video = "Video"
}


public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL
    let caption: String?
    let likeCount: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUsers: [String]
    let owner: User
}

struct PostLike {
    let userName: String
    let postID: String
}

struct PostComment {
    let identifier: String
    let userName: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}

struct CommentLike {
    let userName: String
    let commentID: String
}
