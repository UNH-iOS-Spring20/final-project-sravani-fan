//
//  ZLLoginVC.swift
//  OMG
//
//  Created by mac on 2020/4/3.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class ZLLoginVC: ZLBaseVC {

    @IBOutlet weak var functionWrapper: UIView!
    @IBOutlet weak var lbl0: ZLGradientLabel!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var bottleWapper: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateHeadViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnSignup.setGradientBackground(colorOne: UIColor(red: 1, green: 0.41, blue: 0.42, alpha: 1), colorTwo: UIColor(red: 1, green: 0.69, blue: 0.42, alpha: 1))
        btnSignin.setGradientBackground(colorOne: UIColor(red: 1, green: 0.41, blue: 0.42, alpha: 1), colorTwo: UIColor(red: 1, green: 0.69, blue: 0.42, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(animated)
    }
    
    private func generateHeadViews() {
        let width = 50.0
        let height = 74.0
        let iPhone_Width = Double(UIScreen.main.bounds.width)
        let rects : [CGRect] = [
            CGRect(x: 80, y: 0, width: width, height: height),
            CGRect(x: 80+width*1+10, y: 0, width: width, height: height),
            CGRect(x: 80+width*2+10, y: 0, width: width, height: height),
            
            CGRect(x: 0, y: height-30, width: width, height: height),
            CGRect(x: 0+width*1, y: height-30, width: width, height: height),
            
            CGRect(x: iPhone_Width-width*3, y: height-30, width: width, height: height),
            CGRect(x: iPhone_Width-width*2, y: height-30, width: width, height: height),
            CGRect(x: iPhone_Width-width, y: height-30, width: width, height: height),
            
            CGRect(x: 80, y: height+40, width: width*1.3, height: height*1.3),
            CGRect(x: 80+width*1+10, y: height+40, width: width*1.3, height: height*1.3),
            CGRect(x: 80+width*2+10, y: height+40, width: width*1.3, height: height*1.3),
            
            CGRect(x: 100, y: height*2.3+40, width: width*1.5, height: height*1.5),
            CGRect(x: 100+width*1+10, y: height*2.3+40, width:1.5*width, height: height*1.5),
        ]
        for i in 0...12 {
            let view : ZLImageBottle = Bundle.main.loadNibNamed("ZLImageBottle", owner: nil, options: nil)?.first as! ZLImageBottle
            view.frame = rects[i]
            bottleWapper.addSubview(view)
            
        }
    }
    
    @IBAction func actionOnSignUp(_ sender: Any) {
        navigationController?.pushViewController(ZLSignUpVC(), animated: true)
    }
    
    @IBAction func actionOnSignIn(_ sender: Any) {
        navigationController?.pushViewController(ZLSignInVC(), animated: true)
    }

}
