//
//  EditLookingForView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/25.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class EditLookingForView: CompleteBaseView {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var friendsBtn: UIButton!
    @IBOutlet weak var classmates: UIButton!
    @IBOutlet weak var bothButton: UIButton!
    override func setupUI(){
        Bundle.main.loadNibNamed("EditLookingForView", owner: self, options: nil)
        addSubview(backgroundView)
        backgroundView.frame = self.bounds
        backgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.setGradientBackground(colorOne: UIColor.hex(hexString: "#FFDF7C"),
                                          colorTwo: UIColor.hex(hexString: "#FF8D00"),
                                          startPoint: CGPoint.init(x: 0.5, y: 0),
                                          endPoint: CGPoint.init(x: 0.5, y: 1))
        
        friendsBtn.setTitleColor(UIColor.hex(0xFF686B), for: .highlighted)
        friendsBtn.setBackgroundImage(UIImage.imageWithColor(color: .white, size: friendsBtn.frame.size), for: .highlighted)
        friendsBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.init(white: 0, alpha: 0.2), size: friendsBtn.frame.size), for: .normal)
        classmates.setTitleColor(UIColor.hex(0xFF686B), for: .highlighted)
        classmates.setBackgroundImage(UIImage.imageWithColor(color: .white, size: classmates.frame.size), for: .highlighted)
        classmates.setBackgroundImage(UIImage.imageWithColor(color: UIColor.init(white: 0, alpha: 0.2), size: friendsBtn.frame.size), for: .normal)
        bothButton.setTitleColor(UIColor.hex(0xFF686B), for: .highlighted)
        bothButton.setBackgroundImage(UIImage.imageWithColor(color: .white, size: bothButton.frame.size), for: .highlighted)
        bothButton.setBackgroundImage(UIImage.imageWithColor(color: UIColor.init(white: 0, alpha: 0.2), size: friendsBtn.frame.size), for: .normal)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        let items = ["friends", "classmates", "friends and classmates"]
        
        self.dismiss()
        let userInfo = ResUser.user?.userInfo
        userInfo?.tempStr21th = items[sender.tag]
        ResUser.user?.save()
        ProfileManager.canOpenProfile()
        
        self.updateUserInfo()
    }
    
}
