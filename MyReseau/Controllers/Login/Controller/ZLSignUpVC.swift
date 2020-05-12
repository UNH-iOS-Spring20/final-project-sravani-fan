//
//  ZLSignUpVC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/4.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import PKHUD
import FirebaseAuth
class ZLSignUpVC: ZLBaseVC,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewUsername: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPsw: UITextField!
    
    @IBOutlet weak var tvPrototol: UITextView!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblUsernameError: UILabel!
    @IBOutlet weak var lblPswError: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        btnSignUp.setGradientBackground(colorOne: UIColor(red: 1, green: 0.41, blue: 0.42, alpha: 1), colorTwo: UIColor(red: 1, green: 0.69, blue: 0.42, alpha: 1), startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
        viewEmail.layer.cornerRadius = 10;
        viewEmail.layer.borderColor = UIColor(hex: 0xFFAD6C).cgColor
        viewEmail.layer.borderWidth = 0.5
        
        viewUsername.layer.cornerRadius = 10;
        viewUsername.layer.borderColor = UIColor(hex: 0xFFAD6C).cgColor
        viewUsername.layer.borderWidth = 0.5
        
        viewPassword.layer.cornerRadius = 10;
        viewPassword.layer.borderColor = UIColor(hex: 0xFFAD6C).cgColor
        viewPassword.layer.borderWidth = 0.5
        
        let agreement = "Service Agreement"
        let policy = "Privacy Policy"
        let ar = tvPrototol.text.range(of: agreement)!
        let al = tvPrototol.text.distance(from: tvPrototol.text.startIndex, to: ar.lowerBound)
        let nsA = NSRange(location: al, length: agreement.count)
        let pr = tvPrototol.text.range(of: policy)!
        let pl = tvPrototol.text.distance(from: tvPrototol.text.startIndex, to: pr.lowerBound)
        let nsP = NSRange(location: pl, length: policy.count)
        
        
        let attr = NSMutableAttributedString(string: tvPrototol.text, attributes: [.font:UIFont.systemFont(ofSize: 12)])
        
        
        tvPrototol.attributedText = attr
        tvPrototol.linkTextAttributes = [.foregroundColor:UIColor.hex(0xFF686B),
                                         .backgroundColor:UIColor.clear
        ]
        
        view.backgroundColor = UIColor.hex(hexString: "F3F3F3")
    }

    @IBAction func actionOnAgree(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func actionOnSignUp2(_ sender: Any) {
        if tfEmail.text?.count == 0 {

            HUD.flash(.label("Email is required."), delay: 1)
            return
        }

        if !tfEmail.text!.contains("@") {

            HUD.flash(.label("Email format error"), delay: 1)
            return
        }

        viewEmail.layer.borderColor = UIColor(hex: 0xFFAD6C).cgColor
        lblEmailError.text = ""

        if tfUsername.text?.count == 0 {

            HUD.flash(.label("Username is required."), delay: 1)
            return
        }

        if tfUsername.text!.count < 6 {

            HUD.flash(.label("Username cannot be less than 6 characters."), delay: 1)
            return
        }

        viewUsername.layer.borderColor = UIColor(hex: 0xFFAD6C).cgColor
        lblEmailError.text = ""

        if tfPsw.text?.count == 0 {
            HUD.flash(.label("Password is required."), delay: 1)
            return
        }

        if tfPsw.text!.count < 6 {
            HUD.flash(.label("Password cannot be less than 6 characters."), delay: 1)
            return
        }

        viewPassword.layer.borderColor = UIColor(hex: 0xFFAD6C).cgColor
        lblEmailError.text = ""

        var p : [String:Any] = [:]
        p["appType"] = 1
        p["clientNum"] = "1.0.0-beta"
        p["email"] = tfEmail.text!
        p["nickName"] = tfUsername.text!
        p["password"] = tfPsw.text!
        p["clientNum"] = clientNum
        p["appType"] = appType
        HUD.flash(.progress, delay: 60)

        Auth.auth().createUser(withEmail: self.tfEmail.text ?? "", password: self.tfPsw.text ?? "") {(result, error) in
            guard let _ = result?.user, error == nil else{
                HUD.flash(.label(error?.localizedDescription), delay: 1)
                return
            }
            ReseauUser = result?.user
            
            let user = ResUser.user
            user?.userInfo.firebaseUID = result?.user.uid
            user?.userInfo.nickName = self.tfUsername.text
            user?.save()
            do {
                UserDefaults.standard.set(true, forKey: "login")
                
                let encoder = JSONEncoder()
                let data = try encoder.encode(ResUser.user?.userInfo)
                print("struct convert to data")

                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                ReseauDB.collection(fireCollectionUserKey).document(ReseauUser?.uid ?? "").setData(dict as! [String : Any]){ err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        HUD.hide()
                    } else {
                        let vc = ZLSignUp2VC()
                        vc.email = self.tfEmail.text
                        vc.psw = self.tfPsw.text
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } catch {
                print(error)
            }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let vc = ZLWebVC(URL: URL)
        if URL.absoluteString.hasSuffix("privacy.html") {
            vc.title = "Privacy Policy"
        } else {
            vc.title = "Service Agreement"
        }
        navigationController?.pushViewController(vc, animated: true)
        return false;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 {
            return true
        }
        if textField == tfUsername {
            if string.contains("@") {
                return false
            }
        }
        return true
    }

    
}
