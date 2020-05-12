//
//  SettingVC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/19.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import JXPopupView
import FirebaseAuth
class SettingVC: ZLBaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    @objc private func actionOnClickedMenu(_ guesture:UITapGestureRecognizer) {
        switch guesture.view?.tag {
        case 200:
            navigationController?.pushViewController(FeedBackVC(), animated: true)
        case 201:
            navigationController?.pushViewController(AboutUsVC(), animated: true)
        case 202:
            let contentView = LogoutView({
                do {
                    try Auth.auth().signOut()
                } catch {
                    
                }
                UserDefaults.standard.removeObject(forKey: "login")
                ResUser().save()
                self.navigationController?.popToRootViewController(animated: false)
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kPushLoginControllerNotice), object: nil)
            })
            let popupView = JXPopupView(containerView: UIApplication.shared.keyWindow!, contentView: contentView, animator: JXPopupViewZoomInOutAnimator())
            popupView.isDismissible = true
            popupView.isInteractive = true
            popupView.isPenetrable = false
            popupView.backgroundView.blurEffectStyle = .light
            popupView.backgroundView.color = UIColor.black.withAlphaComponent(0.6)
            popupView.display(animated: true, completion: nil)
            contentView.cancelBlock = {
                popupView.dismiss(animated: true, completion: nil)
            }
        default: break
            
        }
    }
    private func configUI() {
        title = "Setting";
        view.backgroundColor = UIColor(hex: 0xf3f3f3)
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        scrollView.addSubview(stackView)
        stackView.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(32)
            make.width.equalTo(156)
        }
        let icons = ["mevideo","memonment","mesetting"]
        let titles = ["Feedback","About Us","Sign Out"]
        for i in 0...2 {
            let item = UIView()
            item.backgroundColor = UIColor.white
            item.clipsToBounds = true
            item.layer.cornerRadius = 15
            item.tag = 200 + i
            let g = UITapGestureRecognizer(target: self, action: #selector(actionOnClickedMenu))
            item.addGestureRecognizer(g)
            stackView.addArrangedSubview(item)
            
            let icon = UIImageView(image: UIImage(named:icons[i]))
            item.addSubview(icon)
            let label = UILabel()
            label.font = UIFont(name: "ArialMT", size: 16)
            label.text = titles[i]
            item.addSubview(label)
            
            icon.snp_makeConstraints { (make) in
                make.top.equalTo(15)
                make.height.equalTo(54)
                make.width.equalTo(54)
                make.centerX.equalToSuperview()
            }
            
            label.snp_makeConstraints { (make) in
                make.top.equalTo(icon.snp_bottom).offset(20)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(-13)
            }
        }
    }
}
