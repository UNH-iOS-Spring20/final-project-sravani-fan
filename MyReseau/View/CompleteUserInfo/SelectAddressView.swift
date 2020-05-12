//
//  SelectAddressView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/25.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class SelectAddressView: CompleteBaseView {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    override func setupUI(){
        Bundle.main.loadNibNamed("SelectAddressView", owner: self, options: nil)
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
    
    @IBAction func selectAddress(_ sender: Any) {
        self.dismiss()
        let locationDetailVC = ZLLocationSelectVC(datas: nil, type: 1);
        locationDetailVC.complete = { location in
            var p:[String:Any] = [
                "clientNum":clientNum,
                "appType":appType
            ]
            let country = location.first as? Location
            p["country"] = country?.name
            p["countryId"] = country?.id
            p["tempStr6th "] = country?.code
            if location.count > 1 {
                let province = location[1] as? Location
                p["province"] = province?.name
                p["provinceId"] = province?.id
                p["tempStr5th"] = province?.code
            }
            if location.count > 2 {
                let province = location[2] as? Location
                p["city"] = province?.name
                p["cityId"] = province?.id
            }

            
            let userInfo = ResUser.user?.userInfo
            userInfo?.country = p["country"] as? String
            userInfo?.countryId = p["countryId"] as? Int
            userInfo?.tempStr6th = p["tempStr6th"] as? String
            userInfo?.province = p["province"] as? String
            userInfo?.provinceId = p["provinceId"] as? Int
            userInfo?.tempStr5th = p["tempStr5th"] as? String
            userInfo?.city = p["city"] as? String
            userInfo?.cityId = p["cityId"] as? Int
            ResUser.user?.save()
            ProfileManager.canOpenProfile()
            
            self.updateUserInfo()
        }
        topVC?.navigationController?.pushViewController(locationDetailVC, animated: true)
    }
    
}
