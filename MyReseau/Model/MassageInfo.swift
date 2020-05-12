//
//  MassageInfo.swift
//  MyReseau
//
//  Created by fan li on 2020/3/16.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import KakaJSON

class CommentsInfo: Codable, Convertible {
    required init() {
        userInfo = UserInfo()
    }
    var content: String?
    var userInfo: UserInfo?
}

class MassageInfo: Codable, Convertible {
    required init() {
        userInfo = UserInfo()
    }
    var appType: Int?
    var audioUrl: String?
    var commentNewNum: Int?
    var commentNum: Int?
    var content: String?
    var createTime: Int?
    var decentStatus: Int?
    var delFlag: Int?
    var gmId: Int?
    var id: Int?
    var imgUrl: String?
    var racyStatus: Int?
    var recommendStatus: Int?
    var reviewStatus: Int?
    var updateTime: Int?
    var upvoteNewNum: Int?
    var upvoteNum: Int?
    var userId: Int?
    var userInfo: UserInfo?
    var videoUrl: String?
    var fireDBID: String?
    
    var openMessageUID: String?
    
    var commentList = Array<CommentsInfo>()
}
