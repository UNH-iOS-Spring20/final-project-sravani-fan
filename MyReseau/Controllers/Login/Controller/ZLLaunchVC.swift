//
//  ZLLaunchVC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/8.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

let kLoginSuccessNotice = "kLoginSuccessNotice"

class ZLLaunchVC: ZLBaseVC {

    @IBOutlet weak var imgHead: UIImageView!
    @IBOutlet weak var headViewContainer: UIView!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(popToHomeVC), name: NSNotification.Name.init(rawValue: kLoginSuccessNotice), object: nil)
        for view in self.headViewContainer.subviews {
            view.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        UIView.animate(withDuration: 0.5, animations: {
            for view in self.headViewContainer.subviews {
                view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
        }) { (complete) in
            UIView.animate(withDuration: 0.5, animations: {
                for view in self.headViewContainer.subviews {
                    view.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }) { (complete) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.btnSignIn.alpha = 1.0
                    self.btnSignUp.alpha = 1.0
                    self.imgHead.alpha = 1.0;
                    self.cancelBtn.alpha = 1.0
                }) { (complete) in
                    
                }
            }
        }
    }
    
    @objc func popToHomeVC() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelAction(_ sender: Any) {
        popToHomeVC()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(animated)
    }

    //MARK:- Target Method
    @IBAction func actionOnSignUp(_ sender: Any) {
        navigationController?.pushViewController(ZLSignUpVC(), animated: true)
    }
    
    @IBAction func actionOnSignIn(_ sender: Any) {
        navigationController?.pushViewController(ZLSignInVC(), animated: true)
    }
}
