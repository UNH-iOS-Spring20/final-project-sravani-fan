//
//  EditBasicTipView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/25.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class EditBasicTipView: CompleteBaseView {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var avatarImg: UIImageView!
    
    override func setupUI(){
        Bundle.main.loadNibNamed("EditBasicTipView", owner: self, options: nil)
        addSubview(backgroundView)
        backgroundView.frame = self.bounds
        backgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.setGradientBackground(colorOne: UIColor.hex(hexString: "#FFDF7C"),
                                          colorTwo: UIColor.hex(hexString: "#FF8D00"),
                                          startPoint: CGPoint.init(x: 0.5, y: 0),
                                          endPoint: CGPoint.init(x: 0.5, y: 1))
        
        avatarImg.layer.cornerRadius = avatarImg.height * 0.5
        avatarImg.clipsToBounds = true
        avatarImg.layer.borderColor = UIColor.white.cgColor
        avatarImg.layer.borderWidth = 2
        avatarImg.contentMode = .scaleAspectFill
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss()
    }
    
    
    @IBAction func comfirmAction(_ sender: Any) {
        self.dismiss()
        ProfileManager.isOpenBaseView = true
        ProfileManager.canOpenProfile()
    }
}
