//
//  CompleteBaseView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/25.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class CompleteBaseView: UIView {
    let titleImgView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        titleImgView.image = UIImage.init(named: "EditYourProfile")
        self.addSubview(titleImgView)
        titleImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(statusBarHeight + 22)
            make.width.equalTo(195)
            make.height.equalTo(25)
        }
    }

    func dismiss(){
        self.removeFromSuperview()
    }
    
    func updateUserInfo() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(ResUser.user?.userInfo)
            let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            ReseauDB.collection(fireCollectionUserKey).document(ReseauUser?.uid ?? "").setData(dict as! [String : Any])
            print(dict)
        } catch {
            print(error)
        }
    }
}
