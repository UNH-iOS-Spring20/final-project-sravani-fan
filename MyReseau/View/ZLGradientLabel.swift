//
//  ZLGradientLabel.swift
//  MyReseau
//
//  Created by fan li on 2020/4/3.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class ZLGradientLabel: UILabel {
    
    @IBInspectable var color1 : UIColor?
    @IBInspectable var color2 : UIColor?
    @IBInspectable var color3 : UIColor?
    
    var _colors : [CGColor] = []
    var colors : Array<CGColor> {
        get{
            var a = Array<CGColor>()
            if (color1 != nil) {
                a.append(color1!.cgColor)
            }
            if (color2 != nil) {
                a.append(color2!.cgColor)
            }
            if (color3 != nil) {
                a.append(color3!.cgColor)
            }
            _colors = a
            return _colors
        }
        set {
            _colors = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
//        gradientLayer.locations = [1.0,0.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = frame
        gradientLayer.mask = layer
        superview?.layer.insertSublayer(gradientLayer, at: 0)
        frame = gradientLayer.bounds
    }

}
