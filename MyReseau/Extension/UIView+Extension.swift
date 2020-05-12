//
//  UIView+Extension.swift
//  MyReseau
//
//  Created by fan li on 2020/4/3.
//  Copyright © 2020 biz. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor, startPoint:CGPoint, endPoint:CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
    }

    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        setGradientBackground(colorOne: colorOne, colorTwo: colorTwo, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
    }
    
    func setGradientBackgroundV() -> Void {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.99, green: 0.87, blue: 0.6, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.41, blue: 0.42, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.69, blue: 0.42, alpha: 1).cgColor,
        ]
        gradient.locations = [0, 0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.frame = self.bounds
        gradient.zPosition = -1
        self.layer.insertSublayer(gradient, at: 0)
        self.layer.masksToBounds = true
    }
}

extension UIView {
    public var left:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newLeft) {
            var frame = self.frame
            frame.origin.x = newLeft
            self.frame = frame
        }
    }
    
    public var y:CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(newTop) {
            var frame = self.frame
            frame.origin.y = newTop
            self.frame = frame
        }
    }
    
    public var width:CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    public var height:CGFloat {
        get {
            return self.frame.size.height
        }
        
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    public var right:CGFloat {
        get {
            return self.left + self.width
        }
    }
    
    public var bottom:CGFloat {
        get {
            return self.y + self.height
        }
    }
    
    public var centerX:CGFloat {
        get {
            return self.center.x
        }
        
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }
    
    public var centerY:CGFloat {
        get {
            return self.center.y
        }
        
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }
}
