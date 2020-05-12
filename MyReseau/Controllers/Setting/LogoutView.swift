//
//  LogoutView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/20.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import TangramKit

class LogoutView: UIView {
    
    var completeBlock : (()->Void)?
    var cancelBlock : (()->Void)?
    
    init(_ completeBlock:@escaping (()->Void)) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-30, height: 270))
        self.center = CGPoint(x: UIScreen.main.bounds.width/2.0, y: UIScreen.main.bounds.height/2.0)
        self.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-30, height: 270)
        self.completeBlock = completeBlock
        configUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func actionOnCacel(_ sender:UIButton) {
        cancelBlock?()
    }
    
    @objc private func actionOnComplete(_ sender:UIButton) {
        completeBlock?()
        cancelBlock?()
    }
    
    private func configUI() {
        backgroundColor = .white
        self.layer.applyStyle.cornerRadius(15).masksToBounds(true)
        let r = TGRelativeLayout()
        r.tg_size(.fill)
        addSubview(r)
        let lblMsg = UILabel()
        lblMsg.text = "Are you sure you want to sign out？"
        lblMsg.applyStyle.font(.boldSystemFont(ofSize: 18)).textColor(.hex(0xFF6A6B)).numberOfLines(0).textAlignment(.center)
        lblMsg.tg_centerX.equal(r)
        lblMsg.tg_top.equal(70)
        lblMsg.tg_size(.wrap)
        lblMsg.tg_width.equal(.fill)
        r.addSubview(lblMsg)
        
        let line = UIView()
        line.backgroundColor = .hex(0xFFB6A5)
        line.tg_top.equal(lblMsg.tg_bottom).offset(70)
        line.tg_height.equal(1)
        line.tg_width.equal(.fill)
        r.addSubview(line)
        
        let l = TGLinearLayout(.horz)
        l.tg_padding = UIEdgeInsets(top: 27, left: 34, bottom: 27, right: 34)
        l.tg_width.equal(.fill)
        l.tg_height.equal(.wrap)
        l.tg_top.equal(line.tg_bottom)
        l.tg_gravity = .center
        l.tg_bottom.equal(0)
        l.tg_space = 20
        
        var btn = UIButton()
        btn.applyStyle.title("Cancel", for: .normal).clipsToBounds(true).titleColor(.white, for: .normal).frame(CGRect(x: 0, y: 0, width: 130, height: 40)).addTarget(self, action: #selector(actionOnCacel(_:)), for: .touchUpInside)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 20
        btn.setGradientBackground(colorOne: UIColor(red: 1, green: 0.41, blue: 0.42, alpha: 1), colorTwo: UIColor(red: 1, green: 0.69, blue: 0.42, alpha: 1), startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
        l.addSubview(btn)
        
        btn = ZLGradientBorderButton()
        btn.applyStyle.title("Sign out", for: .normal).clipsToBounds(true).titleColor(.hex(0xFF686B), for: .normal).frame(CGRect(x: 0, y: 0, width: 130, height: 40)).addTarget(self, action: #selector(actionOnComplete(_:)), for: .touchUpInside)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 20
        l.addSubview(btn)
        r.addSubview(l)
        
        let size = r.tg_sizeThatFits()
        bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    override func draw(_ rect: CGRect) {
        
    }

}
