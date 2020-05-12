//
//  AboutUsVC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/20.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
@_exported import TangramKit

class AboutUsVC: ZLBaseVC {

    private var versionLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0xf3f3f3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    @objc private func actionOnClickedMenu(_ sender:UITapGestureRecognizer) {
        let tag = sender.view?.tag
        if tag == 200 {
           let path = Bundle.main.path(forResource: "policy", ofType: "html")
            let vc = ZLWebVC(URL: URL(string: path ?? "")!)
            vc.title = "Service Agreement"
            navigationController?.pushViewController(vc, animated: true)
        } else if tag == 201 {
           let path = Bundle.main.path(forResource: "policy", ofType: "html")
            let vc = ZLWebVC(URL: URL(string: path ?? "")!)
            vc.title = "Privacy Policy"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func setupUI() {
        title = "About us"
        let l = TGFlowLayout(.vert,arrangedCount: 1)
        l.tg_width.equal(view)
        l.tg_height.equal(.wrap)
        l.tg_space = 13
        l.tg_gravity = TGGravity.horz.center
        view.addSubview(l)
        
        let imgLogo = UIImageView(image: UIImage(named: "omg"))
        imgLogo.tg_top.equal(47)
        imgLogo.tg_width.equal(130)
        imgLogo.tg_height.equal(130)
        l.addSubview(imgLogo)
        
        let lblName = UILabel()
        lblName.applyStyle.font(.systemFont(ofSize: 18)).text("Reseau")
        lblName.tg_size(.wrap)
        l.addSubview(lblName)
        
        let lblVersion = UILabel()
        
        lblVersion.text = "Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)"
        lblVersion.font = .systemFont(ofSize: 16)
        lblVersion.tg_size(.wrap)
        versionLabel = lblVersion
        l.addSubview(lblVersion)
        l.tg_endLayoutDo {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = lblVersion.frame
            gradientLayer.colors = [UIColor(hex: 0xFF686B).cgColor,UIColor(hex: 0xFFB06C).cgColor]
            gradientLayer.startPoint = CGPoint(x:0, y:0.5)
            gradientLayer.endPoint = CGPoint(x:1, y:0.5)
            lblVersion.superview?.layer.insertSublayer(gradientLayer, at: 0)
            gradientLayer.mask = lblVersion.layer
            DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
                self.versionLabel!.layer.frame = gradientLayer.bounds
            }
        }
        
        let m0 = menuWithTitle("Service Agreement")
        m0.tag = 200
        m0.tg_top.equal(47)
        m0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionOnClickedMenu(_:))))
        l.addSubview(m0)
        
        let m1 = menuWithTitle("Privacy Policy")
        m1.tag = 201
        m1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionOnClickedMenu(_:))))
        l.addSubview(m1)
    }
    
    private func menuWithTitle(_ title:String) -> UIView {
        let r = TGRelativeLayout()
        r.tg_height.equal(60).and().tg_width.equal(UIScreen.main.bounds.width-30)
        r.layer.cornerRadius = 5
        r.clipsToBounds = true
        r.backgroundColor = .white
        
        let lbl = UILabel()
        lbl.applyStyle.font(.systemFont(ofSize: 15)).text(title)
        lbl.tg_leading.equal(20).and().tg_centerY.equal(0).and().tg_size(.wrap)
        r.addSubview(lbl)
        
        let imgMore = UIImageView(image: UIImage(named: "more"))
        imgMore.tg_trailing.equal(13).and().tg_centerY.equal(0).and().tg_width.equal(15).and().tg_height.equal(22)
        r.addSubview(imgMore)
        return r
    }
    
}

