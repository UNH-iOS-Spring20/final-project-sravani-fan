//
//  SignUpToken.swift
//  MyReseau
//
//  Created by fan li on 2020/4/7.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class TokenDto: Codable {
    var token : String?
    var refreshToken : String?
    var expiresIn : Int?
}

class SignUpToken: Codable {
    var userId : Int?
    var tokenDto : TokenDto?
}
