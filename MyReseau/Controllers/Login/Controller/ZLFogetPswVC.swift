//
//  ZLFogetPswVC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/8.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import PKHUD

class ZLFogetPswVC: ZLBaseVC {
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forget Password"
        btnSignUp.setGradientBackground(colorOne: UIColor(red: 1, green: 0.41, blue: 0.42, alpha: 1), colorTwo: UIColor(red: 1, green: 0.69, blue: 0.42, alpha: 1), startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
        viewEmail.layer.cornerRadius = 10;
        viewEmail.layer.borderColor = UIColor(hex: 0xFFAD6C).cgColor
        viewEmail.layer.borderWidth = 0.5
    }
    
    @IBAction func actionOnDone(_ sender: Any) {
        view.endEditing(true)
        if tfEmail.text?.count == 0 {
             HUD.flash(.label("Please input your email."),delay: 1)
             return
         }

         if !tfEmail.text!.contains("@") {
             HUD.flash(.label("Email format error."),delay: 1)
             return
         }
        
        HUD.flash(.progress,delay: 2)
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            HUD.hide()
            HUD.flash(.label("Reset password connection sent successfully."),delay: 1)
        }
    }
    
}
