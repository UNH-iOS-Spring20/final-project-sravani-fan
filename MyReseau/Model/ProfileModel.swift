//
//  ProfileModel.swift
//  MyReseau
//
//  Created by fan li on 2020/4/19.
//  Copyright © 2020 biz. All rights reserved.
//

import Foundation

class CommentModel: Codable {
    var commentId: Int?
    var content: String?
    var userId: Int?
}

class CommentCountModel: Codable {
    var content: String?
    var contentCount: Int?
    var userId: Int?
}

class ProfileModel: Codable {
    var attentionState: Int?
    var comment: CommentModel?
    var commentCount: [CommentCountModel]?
    var distance: Int?
    var photos: [Photo]?
    var upvoteState: Int?
    var userInfo: UserInfo?
}
