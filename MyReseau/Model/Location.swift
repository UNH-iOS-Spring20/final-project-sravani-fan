//
//  Location.swift
//  MyReseau
//
//  Created by fan li on 2020/4/9.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import KakaJSON
protocol OptionData : Codable {
    var id : Int? { get set }
    var name : String? { get set }
}


class Location: OptionData, Convertible {
    required init() {
    }
    var id: Int?
    var name: String?
    var sn: Int?
    var code: String?
    var parentId : Int?
    
    init(id:Int?,name:String?,code:String?) {
        self.id = id
        self.name = name
        self.code = code
    }
}

