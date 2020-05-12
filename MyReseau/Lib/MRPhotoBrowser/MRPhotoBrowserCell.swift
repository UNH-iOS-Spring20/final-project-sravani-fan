//
//  MRPhotoBrowserCell.swift
//  MRPhotoBrowser
//
//  Created by biz on 2020/4/6.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

public protocol MRPhotoBrowserCell: UIView {
    
    static func generate(with browser: MRPhotoBrowser) -> Self
}
