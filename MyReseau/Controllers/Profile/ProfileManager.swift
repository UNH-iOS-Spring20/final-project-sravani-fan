//
//  ProfileManager.swift
//  MyReseau
//
//  Created by fan li on 2020/4/25.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

let mainBounds = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)

class ProfileManager {
    static var isOpenBaseView = false
    static var imgURL:String?
  
    class func openProfileVC(userID uid : String, imgUrl url: String) -> ProfileViewController? {
        imgURL = url
        if canOpenProfile() == false {
            return nil
        }
        let vc = ProfileViewController()
        vc.userID = uid
        vc.fireBaseUID = uid
        return vc
    }
    @discardableResult
    class func canOpenProfile() -> Bool {
        let user = ResUser.user?.userInfo
        if user?.imgStatus == 3 {
            openEditPhotoRefuse()
            return false
        }else{
            
            if user?.imgUrl == nil && user?.tempStr7th == nil{
                if checkOpenBaseTipView() == false {return false}
                openEditPhoto()
                return false
            }else if user?.gender == nil || user?.gender == 0 {
                if checkOpenBaseTipView() == false {return false}
                openChooseGender()
                return false
            }else if user?.country == nil || user?.country?.count == 0 {
                if checkOpenBaseTipView() == false {return false}
                openLocation()
                return false
            }else if user?.spareStr1st == nil || user?.spareStr1st?.count == 0 || (user?.spareStr1st!.hasPrefix("Please") == true){
                if checkOpenBaseTipView() == false {return false}
                openChooseHeight()
                return false
            }else if user?.spareStr9th == nil || user?.spareStr9th?.count == 0 {
                if checkOpenBaseTipView() == false {return false}
                openChooseEducation()
                return false
            }else if user?.spareStr8th == nil || user?.spareStr8th?.count == 0 {
                if checkOpenBaseTipView() == false {return false}
                openChooseOccupation()
                return false
            }

            else if user?.tempStr12th == nil || user?.tempStr12th?.count == 0 {
                if checkOpenBaseTipView() == false {return false}
                openChoosereseauFor()
                return false
            }else if user?.tempStr21th == nil || user?.tempStr21th?.count == 0 {
                if checkOpenBaseTipView() == false {return false}
                openChooseLookingFor()
                return false
            }else if (user?.tempStr1st == nil || user?.tempStr1st?.count == 0) &&
                (user?.tempStr2nd == nil || user?.tempStr2nd?.count == 0){
                if checkOpenBaseTipView() == false {return false}
                openEditIntroduction()
                return false
            }else if user?.spareNum1st == nil || user?.spareNum1st == 3{
                if checkOpenBaseTipView() == false {return false}
                openEditIntroduction()
                return false
            }
        }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(ResUser.user?.userInfo)
            print("struct convert to data")

            let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            ReseauDB.collection(fireCollectionUserKey).document(ReseauUser?.uid ?? "").setData(dict as! [String : Any])
            print(dict)

        } catch {
            print(error)
        }
        return true
    }

    class func openEditPhotoRefuse(){
        let view = EditPhotoView.init(frame: mainBounds)
        view.tipLabel.text = "Your photo has been refuse.\nPlease upload it again."
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    class func checkOpenBaseTipView() -> Bool{
        if isOpenBaseView == false {
            let view = EditBasicTipView.init(frame: mainBounds)
            view.avatarImg.kf.setImage(urlString: imgURL)
            UIApplication.shared.keyWindow?.addSubview(view)
            return false
        }
        return true
    }
    
    class func openEditPhoto(){
        let view = EditPhotoView.init(frame: mainBounds)
        view.tipLabel.text = "Upload your photo"
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    class func openChooseGender() {
        let view = ChooseGenderView.init(frame: mainBounds)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    class func openLocation() {
        let view = SelectAddressView.init(frame: mainBounds)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    class func openChooseHeight() {
        let view = ChooseHeightView.init(frame: mainBounds)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    class func openChooseEducation() {
        let view = ChooseEducationView.init(frame: mainBounds)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    class func openChooseOccupation() {
        let view = ChooseOccupationView.init(frame: mainBounds)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    
    class func openChoosereseauFor() {
        let view = EditreseauView.init(frame: mainBounds)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    class func openChooseLookingFor() {
        let view = EditLookingForView.init(frame: mainBounds)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    class func openEditIntroduction() {
        let view = EditIntroductionView.init(frame: mainBounds)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
}
