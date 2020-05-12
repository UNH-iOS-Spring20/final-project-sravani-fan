//
//  MRPhotoBrowserPageIndicator.swift
//  MRPhotoBrowser
//
//  Created by biz on 2020/4/6.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

public protocol MRPhotoBrowserPageIndicator: UIView {
    
    func setup(with browser: MRPhotoBrowser)
    
    func reloadData(numberOfItems: Int, pageIndex: Int)
    
    func didChanged(pageIndex: Int)
}
