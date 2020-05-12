//
//  ChooseGenderView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/25.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class ChooseGenderView: CompleteBaseView {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!

    override func setupUI(){
        Bundle.main.loadNibNamed("ChooseGenderView", owner: self, options: nil)
        addSubview(backgroundView)
        backgroundView.frame = self.bounds
        backgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.setGradientBackground(colorOne: UIColor.hex(hexString: "#FFDF7C"),
                                          colorTwo: UIColor.hex(hexString: "#FF8D00"),
                                          startPoint: CGPoint.init(x: 0.5, y: 0),
                                          endPoint: CGPoint.init(x: 0.5, y: 1))
        super.setupUI()
    }
    
    @IBAction func genderAction(_ sender: UIButton) {
        
        self.dismiss()
        let userInfo = ResUser.user?.userInfo
        userInfo?.gender = sender.tag
        ResUser.user?.save()
        ProfileManager.canOpenProfile()
        
        self.updateUserInfo()
    }
    
}
