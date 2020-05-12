//
//  MRPhotoBrowserZoomSupportedCell.swift
//  MRPhotoBrowser
//
//  Created by biz on 2020/4/6.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

/// 在Zoom转场时使用
protocol MRPhotoBrowserZoomSupportedCell: UIView {
    /// 内容视图
    var showContentView: UIView { get }
}
