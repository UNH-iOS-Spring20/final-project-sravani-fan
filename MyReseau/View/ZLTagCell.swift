//
//  ZLTagCell.swift
//  MyReseau
//
//  Created by mac on 2020/4/4.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class ZLTagCell: UICollectionViewCell {
    lazy var lbl: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    lazy var gradientLayer : CAGradientLayer = {
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.99, green: 0.87, blue: 0.6, alpha: 1).cgColor, UIColor(red: 1, green: 0.41, blue: 0.42, alpha: 1).cgColor, UIColor(red: 1, green: 0.69, blue: 0.42, alpha: 1).cgColor]
        gradient1.locations = [0, 0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = contentView.bounds
        return gradient1
    }()
    
    var _isSelectedState : Bool = false
    var isSelectedState : Bool {
        get {
            _isSelectedState
        }
        set {
            _isSelectedState = newValue
            if newValue {
                lbl.textColor = UIColor.white
                gradientLayer.isHidden = false;
            } else {
                lbl.textColor = UIColor.black
                gradientLayer.isHidden = true;
            }
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(lbl)
        lbl.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        gradientLayer.frame = contentView.bounds
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        contentView.backgroundColor = UIColor(hex: 0xCCCBCA)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        gradientLayer.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if !gradientLayer.isHidden {
//            UIView.performWithoutAnimation {
//                gradientLayer.frame = contentView.bounds
//            }
//        }
//    }
}
