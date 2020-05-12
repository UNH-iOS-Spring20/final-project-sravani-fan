//
//  ZLGradientBorderButton.swift
//  MyReseau
//
//  Created by fan li on 2020/4/9.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class ZLGradientBorderButton: UIButton {

    var colors : [UIColor] = []
    override func draw(_ rect: CGRect) {
        let context:CGContext =  UIGraphicsGetCurrentContext()!
        context.setAllowsAntialiasing(true) //抗锯齿设置
        super.draw(rect)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.size.height/2.0)

        let layer = CAShapeLayer()
        layer.frame = rect
        layer.lineWidth = 3
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.red.cgColor
        layer.path = path.cgPath
        self.layer.addSublayer(layer)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
        gradientLayer.colors = [UIColor.hex(0xFF686B).cgColor,UIColor.hex(0xFFAE6C).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.mask = layer
        
        self.layer.addSublayer(gradientLayer)
        
    }

}
