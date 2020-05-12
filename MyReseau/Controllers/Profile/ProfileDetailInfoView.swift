//
//  ProfileDetailInfoView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/24.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

let baseButtonTag = 1000

class ProfileDetailInfoView: UIView {
    
    let labelHeight:CGFloat = 35
    
    let nameLabel = fetchLabel()
    let genderLabel = fetchLabel()
    let ageLabel = fetchLabel()
    let addressLabel = fetchLabel()
    let heightLabel = fetchLabel()
    let educationLabel = fetchLabel()
    let occupationLabel = fetchLabel()
    
    let lookingForLabel = fetchRoleLabel()
    var aboutMeLabel: UILabel?
    
    var userInfo: ProfileModel!
    var index = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func updateInfo(userInfo user: ProfileModel) {
        userInfo = user
        basicInformation()
        myRole()
        aboutMe()
        publicPhoto()
        layoutIfNeeded()
        guard let lastView = self.subviews.last else {
            return
        }
        self.height = lastView.y + lastView.height + 36
    }
    
    private func basicInformation() {
        let title = UILabel()
        title.text = "Basic Information"
        title.font = UIFont.init(name: "PingFangSC-Semibold", size: 24)
        title.textColor = UIColor.hex(hexString: "#1E1E1E")
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(28)
            make.top.equalTo(33)
        }
        let nickNameString = userInfo.userInfo?.nickName ?? ""
        nameLabel.text = String("Username : \(nickNameString)")
        nameLabel.sizeToFit()
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp_left)
            make.top.equalTo(title.snp_bottom).offset(28)
            make.height.equalTo(labelHeight)
            make.width.equalTo(nameLabel.width + labelHeight)
        }
        if (userInfo.userInfo?.memberLevel ?? 0) > 0 {
            let vipImg = UIImageView()
            vipImg.image = UIImage.init(named: "omgPremiumMember")
            addSubview(vipImg)
            vipImg.snp.makeConstraints { (make) in
                make.left.equalTo(nameLabel.snp_right).offset(5)
                make.centerY.equalTo(nameLabel.snp_centerY)
                make.width.height.equalTo(35)
            }
        }
        ageLabel.text = String("Age : \(userInfo.userInfo?.age ?? 0)")
        ageLabel.sizeToFit()
        addSubview(ageLabel)
        ageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp_left)
            make.top.equalTo(nameLabel.snp_bottom).offset(17)
            make.height.equalTo(labelHeight)
            make.width.equalTo(ageLabel.width + labelHeight)
        }
        if (userInfo.userInfo?.gender ?? 0) > 0 {
            genderLabel.text = String("I'm a : \(((userInfo.userInfo?.age) == 1) ? "Male":"Female")")
            genderLabel.sizeToFit()
            addSubview(genderLabel)
            genderLabel.snp.makeConstraints { (make) in
                make.left.equalTo(title.snp_left)
                make.top.equalTo(nameLabel.snp_bottom).offset(17)
                make.height.equalTo(labelHeight)
                make.width.equalTo(genderLabel.width + labelHeight)
            }
            
            ageLabel.snp.updateConstraints { (make) in
                make.left.equalTo(title.snp_left).offset(genderLabel.width + labelHeight + 7)
            }
        }
        
        var address = String("Address : \(userInfo.userInfo?.country ?? "")")
        if userInfo.userInfo?.province != nil {
            if userInfo.userInfo?.city != nil {
                address = String("Address : \(userInfo.userInfo?.city ?? "") \(userInfo.userInfo?.tempStr5th ?? "") \(userInfo.userInfo?.tempStr6th ?? "")")
            }else{
                address = String("Address : \(userInfo.userInfo?.province ?? "") \(userInfo.userInfo?.country ?? "")")
            }
        }
        addressLabel.text = (address == "Address : ") ? nil : address
        addressLabel.sizeToFit()
        addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp_left)
            make.top.equalTo(ageLabel.snp_bottom).offset((address == "Address : ") ? 0 : 17)
            make.height.equalTo((address == "Address : ") ? 0 : labelHeight)
            make.width.equalTo(addressLabel.width + labelHeight)
        }
        var height = userInfo.userInfo?.spareStr1st ?? ""
        if height.hasPrefix("Please") == true {
            height = ""
        }
        heightLabel.text = (height.count == 0) ? nil : String("Height : \(height)")
        heightLabel.sizeToFit()
        if (heightLabel.width + 56 + labelHeight) > screenWidth {
            heightLabel.width = screenWidth - 56 - labelHeight
        }
        addSubview(heightLabel)
        heightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp_left)
            make.top.equalTo(addressLabel.snp_bottom).offset((height.count == 0) ? 0 : 17)
            make.height.equalTo((height.count == 0) ? 0:labelHeight)
            make.width.equalTo(heightLabel.width + labelHeight)
        }
        let education = userInfo.userInfo?.spareStr9th ?? ""
        educationLabel.text = (education == "") ? nil:String("Education : \(education)")
        educationLabel.sizeToFit()
        addSubview(educationLabel)
        educationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp_left)
            make.top.equalTo(heightLabel.snp_bottom).offset((education == "") ? 0:17)
            make.height.equalTo((education == "") ? 0:labelHeight)
            make.width.equalTo(educationLabel.width + labelHeight)
        }
        
        let occupation = userInfo.userInfo?.spareStr8th ?? ""
        occupationLabel.text = (occupation == "") ? nil:String("Occupation : \(occupation)")
        occupationLabel.sizeToFit()
        addSubview(occupationLabel)
        occupationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp_left)
            make.top.equalTo(educationLabel.snp_bottom).offset((occupation == "") ? 0:17)
            make.height.equalTo((occupation == "") ? 0:labelHeight)
            make.width.equalTo(occupationLabel.width + labelHeight)
        }
    }
    
    private func myRole() {
        let title = UILabel()
        title.text = "My role"
        title.font = UIFont.init(name: "PingFangSC-Semibold", size: 24)
        title.textColor = UIColor.hex(hexString: "#1E1E1E")
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(28)
            make.top.equalTo(occupationLabel.snp_bottom).offset(39)
        }
        var lastLabel = title
        let role = userInfo.userInfo?.tempStr10th ?? ""
        var maxRight:CGFloat = 28
        var maxTop:CGFloat = 24
        if role.count > 0 {
            let items = role.split(separator: ";")
            for item in items {
                let label = fetchRoleLabel()
                label.text = String(item)
                label.sizeToFit()
                addSubview(label)
                let labelWidth = label.width + labelHeight
                if (maxRight + labelWidth + 15) > (screenWidth - 28) {
                    maxRight = 28
                    maxTop += (labelHeight + 15)
                }
                
                label.snp.makeConstraints { (make) in
                    make.left.equalTo(maxRight)
                    make.top.equalTo(title.snp_bottom).offset(maxTop)
                    make.height.equalTo(labelHeight)
                    make.width.equalTo(labelWidth)
                }
                
                maxRight += (labelWidth + 15)
                
                lastLabel = label
            }
        }
        
        let reseauLabel = fetchRoleLabel()
        reseauLabel.text = String("I`ve been reseau for : \(userInfo.userInfo?.tempStr12th ?? "")")
        reseauLabel.sizeToFit()
        addSubview(reseauLabel)
        reseauLabel.snp.makeConstraints { (make) in
            make.left.equalTo(28)
            make.top.equalTo(lastLabel.snp_bottom).offset((lastLabel == title ? 23 : 15))
            make.height.equalTo(labelHeight)
            make.width.equalTo(reseauLabel.width + labelHeight)
        }
        
        lookingForLabel.text = String("I am looking for : \(userInfo.userInfo?.tempStr21th ?? "")")
        lookingForLabel.sizeToFit()
        addSubview(lookingForLabel)
        lookingForLabel.snp.makeConstraints { (make) in
            make.left.equalTo(28)
            make.top.equalTo(reseauLabel.snp_bottom).offset(15)
            make.height.equalTo(labelHeight)
            make.width.equalTo(lookingForLabel.width + labelHeight)
        }
    }
    
    private func aboutMe(){
        guard let info = userInfo.userInfo?.tempStr1st else {
            return
        }
        let title = UILabel()
        title.text = "About me"
        title.font = UIFont.init(name: "PingFangSC-Semibold", size: 24)
        title.textColor = UIColor.hex(hexString: "#1E1E1E")
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(28)
            make.top.equalTo(lookingForLabel.snp_bottom).offset(39)
        }
        
        aboutMeLabel = UILabel()
        aboutMeLabel?.text = info
        aboutMeLabel?.numberOfLines = 0
        aboutMeLabel?.textColor = UIColor.hex(0x1D1D1D)
        aboutMeLabel?.font = UIFont.systemFont(ofSize: 15)
        addSubview(aboutMeLabel!)
        aboutMeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(28)
            make.right.equalTo(-28)
            make.top.equalTo(title.snp_bottom).offset(25)
        })
    }
    
    private func publicPhoto(){
        
        guard let items = userInfo.photos, items.count > 0 else {
            return
        }
        
        let title = UILabel()
        title.text = "Public Photo"
        title.font = UIFont.init(name: "PingFangSC-Semibold", size: 24)
        title.textColor = UIColor.hex(hexString: "#1E1E1E")
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(28)
            make.top.equalTo((aboutMeLabel ?? lookingForLabel).snp_bottom).offset(39)
        }
        let leftEdge:CGFloat = 17
        let middleEdge:CGFloat = 4
        let width:CGFloat = (screenWidth - leftEdge*2 - middleEdge) / 3
        let height:CGFloat = 160
        for i in 0 ..< items.count {
            let button = UIButton()
            button.contentMode = .scaleAspectFill
            button.backgroundColor = .gray
            button.imageView?.contentMode = .scaleAspectFill
            button.kf.setImage(urlString: fullUrlImage(url: items[i].imgURL),
                                         for: .normal)
            button.tag = i + baseButtonTag
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            addSubview(button)
            let x = (CGFloat(i % 3) * (width + middleEdge)) + leftEdge
            let y = (CGFloat(i / 3) * (height + middleEdge)) + 15
            button.snp.makeConstraints { (make) in
                make.left.equalTo(x)
                make.top.equalTo(title.snp_bottom).offset(y)
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
            button.addTarget(self, action: #selector(tapAvatarAction(_:)), for: .touchUpInside)
            
            guard let lastView = self.subviews.last else {
                return
            }
            self.height = lastView.y + lastView.height + 36
        }
    }
    
    @objc func tapAvatarAction(_ sender: UIButton){
        let tag = sender.tag - baseButtonTag
        guard let items = userInfo.photos, items.count > 0 else {
            return
        }
        let browser = MRPhotoBrowser()
        browser.numberOfItems = {
            items.count
        }
        browser.reloadCellAtIndex = { context in
            self.index = context.index
            let url = items[context.index].imgURL
            let browserCell = context.cell as? MRPhotoBrowserImageCell
            browserCell?.index = context.index
            let button: UIButton = self.viewWithTag(baseButtonTag + context.index) as! UIButton
            let placeholder = button.imageView?.image
            browserCell?.imageView.kf.setImage(with: URL(string: url ?? "" ), placeholder: placeholder, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: { (_, _, _, _) in
                browserCell?.setNeedsLayout()
            })
        }
        browser.transitionAnimator = MRPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
            return sender.imageView
        })
        // 数字样式的页码指示器
        browser.pageIndicator = MRPhotoBrowserNumberPageIndicator()
        browser.pageIndex = tag
        browser.show(method: .push(inNC: topVC?.navigationController))
        let moreBtn = UIButton()
        moreBtn.setBackgroundImage(UIImage.init(named: "profileImagemore"), for: .normal)
        browser.view.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.top.equalTo(statusBarHeight)
            make.height.width.equalTo(36)
        }
        moreBtn.addTarget(self, action: #selector(imageMoreButtonAction), for: .touchUpInside)
    }
    
    @objc func imageMoreButtonAction() {
        let userID = ResUser._user?.userInfo.userId ?? 0
        let otherUserID = userInfo.userInfo?.userId ?? 0
        let imageID = userInfo.photos?[index].id ?? 0
        let key = String("userBlockKey\(userID)_\(otherUserID)")
        var blockKey = "Block"
        if UserDefaults.standard.object(forKey: key) != nil{
            blockKey = "Unblock"
        }
        
        let alertVC = UIAlertController.init()
        let cancelAlert = UIAlertAction.init(title: "Cancel", style: .cancel) { (_) in}
        let reportAlert = UIAlertAction.init(title: "Report", style: .default) { (_) in
            
        }
        reportAlert.setValue(UIColor.hex(hexString: "1E1E1E"), forKey: "titleTextColor")
        let blockAlert = UIAlertAction.init(title: blockKey, style: .default) { (_) in
            HUD.flash(.progress,delay: 60)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                if blockKey == "Block" {
                    UserDefaults.standard.set(true, forKey: key)
                }else{
                    UserDefaults.standard.removeObject(forKey: key)
                }
                HUD.flash(.label("Success"))
            }
        }
        
        blockAlert.setValue(UIColor.hex(hexString: "1E1E1E"), forKey: "titleTextColor")
        cancelAlert.setValue(UIColor.hex(hexString: "FF696B"), forKey: "titleTextColor")
        alertVC.addAction(reportAlert)
        alertVC.addAction(blockAlert)
        alertVC.addAction(cancelAlert)
        topVC?.present(alertVC, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


private func fetchLabel() -> UILabel {
    let label = UILabel()
    label.textColor = UIColor.hex(hexString: "#FF686B")
    label.font = UIFont.systemFont(ofSize: 14)
    label.textAlignment = .center
    label.layer.cornerRadius = 35 * 0.5
    label.clipsToBounds = true
    label.backgroundColor = UIColor.hex(hexString: "#FAD1D2")
    return label
}

private func fetchRoleLabel() -> UILabel {
    let label = UILabel()
    label.textColor = UIColor.hex(hexString: "#FF686B")
    label.font = UIFont.systemFont(ofSize: 14)
    label.textAlignment = .center
    label.clipsToBounds = true
    label.layer.cornerRadius = 35 * 0.5
    label.layer.borderColor = UIColor.hex(hexString: "#FF686B").cgColor
    label.layer.borderWidth = 1
    return label
}
