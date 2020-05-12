//
//  UICollectionReusableView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/4.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class ZLTagHeader: UICollectionReusableView {
    lazy var lbl: UILabel = {
        let label = UILabel();
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lbl);
        lbl.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
