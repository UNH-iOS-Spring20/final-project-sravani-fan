//
//  ZLSignInVC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/6.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import Network
import FirebaseAuth
import FirebaseFirestore

class ZLSignInVC: ZLBaseVC,UITextFieldDelegate {

    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPsw: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        btnSignIn.setGradientBackground(colorOne: UIColor(red: 1, green: 0.41, blue: 0.42, alpha: 1), colorTwo: UIColor(red: 1, green: 0.69, blue: 0.42, alpha: 1), startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
        viewEmail.layer.cornerRadius = 10;
        viewEmail.layer.borderColor = UIColor(hex: 0xFFAD6C).cgColor
        viewEmail.layer.borderWidth = 0.5
        
        viewPassword.layer.cornerRadius = 10;
        viewPassword.layer.borderColor = UIColor(hex: 0xFFAD6C).cgColor
        viewPassword.layer.borderWidth = 0.5

        tfEmail.text = UserDefaults.standard.value(forKey: "email") as? String
        tfPsw.text = UserDefaults.standard.value(forKey: "psw") as? String

    }

    @IBAction func actionOnSignIn(_ sender: Any) {
        view.endEditing(true)
        if tfEmail.text?.count==0 {
            HUD.flash(.label(NSLocalizedString("Please input your email.", comment: "")),delay: 1.0)
            return
        }
        if tfPsw.text?.count==0 {
            HUD.flash(.label(NSLocalizedString("Please input your password.", comment: "")),delay: 1.0)
            return
        }
        if tfPsw.text?.count ?? 0<6 {
            HUD.flash(.label(NSLocalizedString("Password cannot be less than 6 characters.", comment: "")),delay: 1.0)
            return
        }
        
        HUD.flash(.progress,delay: 60)
        Auth.auth().signIn(withEmail: self.tfEmail.text ?? "", password: self.tfPsw.text ?? "") {(result, error) in
            guard let user = result?.user, error == nil else{
                HUD.hide()
                return
            }
            
            UserDefaults.standard.setValue(self.tfPsw.text, forKey: "psw")
            UserDefaults.standard.setValue(self.tfEmail.text, forKey: "email")
            UserDefaults.standard.set(true, forKey: "login")
                            
            ReseauUser = user
            ReseauDB.collection(fireCollectionUserKey).document(user.uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    let user = dataDescription?.kj.model(UserInfo.self)
                    user?.firebaseUID = ReseauUser?.uid
                    let omguser = ResUser.user
                    omguser?.userInfo = user ?? UserInfo()
                    omguser?.save()
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kLoginSuccessNotice), object: nil)
                    HUD.hide()
                } else {
                    HUD.hide()
                }
            }
            
            HUD.flash(.label("Login Success"), delay: 1)
        }
    }
    
    @IBAction func actionOnForgetPsw(_ sender: Any) {
        navigationController?.pushViewController(ZLFogetPswVC(), animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}
