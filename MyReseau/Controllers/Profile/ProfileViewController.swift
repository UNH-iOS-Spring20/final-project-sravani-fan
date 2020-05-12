//
//  ProfileViewController.swift
//  MyReseau
//
//  Created by fan li on 2020/4/23.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import SnapKit
class ProfileViewController: ZLBaseVC {
    var userID: String = ""
    var fireBaseUID: String = ""
    var userInfo: UserInfo?
    let likeButton = UIButton()
    lazy var avatarImg: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.width = self.view.width
        imgView.height = self.view.width
        imgView.image = UIImage.init(named: "default_head")
        return imgView
    }()
    
    lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect.init(x: 0, y: 0, width: view.width, height: view.height)
        scrollView.contentInset = UIEdgeInsets.init(top:0, left: 0, bottom: 90, right: 0)
        scrollView.backgroundColor = .clear
        scrollView.contentSize = CGSize.init(width: view.width, height: view.height * 2)
        return scrollView
    }()
    
    lazy var contentView: ProfileDetailInfoView = {
        let view = ProfileDetailInfoView.init(frame: CGRect.init(x: 0, y: self.view.width - 60, width: self.view.width, height: self.view.height * 4))
        view.backgroundColor = .white
        let maskPath = UIBezierPath.init(roundedRect: view.bounds,
                                         byRoundingCorners: [.topLeft, .topRight],
                                         cornerRadii: CGSize.init(width: 30, height: 30))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        requestData()
    }
    
    private func setupUI() {
        view.addSubview(avatarImg)
        avatarAdjust()
        
        view.addSubview(contentScrollView)
        contentScrollView.delegate = self
        contentScrollView.addSubview(self.contentView)
        
        let avatarBtn = UIButton()
        contentScrollView.addSubview(avatarBtn)
        avatarBtn.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: self.contentView.y)
        avatarBtn.addTarget(self, action: #selector(tapAvatarAction), for: .touchUpInside)
        
        let backBtn = UIButton()
        backBtn.setBackgroundImage(UIImage.init(named: "resProfileBack"),
                                   for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.top.equalTo(statusBarHeight + 3)
            make.width.height.equalTo(36)
        }
        
        let moreBtn = UIButton()
        moreBtn.setBackgroundImage(UIImage.init(named: "resProfileMore"),
                                   for: .normal)
        moreBtn.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
        view.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-18)
            make.top.equalTo(backBtn.snp_top)
            make.width.height.equalTo(36)
        }
        
        let messageButton = UIButton()
        messageButton.setBackgroundImage(UIImage.init(named: "reschat"), for: .normal)
        messageButton.addTarget(self, action: #selector(messageButtonAction), for: .touchUpInside)
        view.addSubview(messageButton)
        messageButton.snp.makeConstraints { (make) in
            make.left.equalTo(90)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(74)
        }
        
        likeButton.setBackgroundImage(UIImage.init(named: "resLike"), for: .normal)
        likeButton.setBackgroundImage(UIImage.init(named: "resLiked"), for: .selected)
        likeButton.addTarget(self, action: #selector(likeButtonAction(_:)), for: .touchUpInside)
        view.addSubview(likeButton)
        likeButton.snp.makeConstraints { (make) in
            make.right.equalTo(-90)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(74)
        }
    }
    
    @objc private func requestData() {
        

        HUD.flash(.progress,delay: 60)
        
        ReseauDB.collection(fireCollectionUserKey).document(self.fireBaseUID).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let user = dataDescription?.kj.model(UserInfo.self)
                
                self.userInfo = user
                self.avatarImg.kf.setImage(urlString: fullUrlImage(url: user?.imgUrl ?? user?.tempStr7th),
                                      placeholder: UIImage.init(named: "default_head"))
                let profileInfo = ProfileModel()
                profileInfo.userInfo = user
                self.contentView.updateInfo(userInfo: profileInfo)
                self.contentScrollView.contentSize = CGSize.init(width: self.view.width, height: self.contentView.y + self.contentView.height)
                self.likeButton.isSelected = false
                HUD.hide()
            } else {
                HUD.flash(.label("Document does not exist"),delay: 1)
                print("Document does not exist")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if topVC?.isKind(of: ZLHomeVC.self) == true {
            return
        }
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

// MARK: - uiscrollView Delegate
extension ProfileViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        let edge = scrollView.contentOffset.y + statusBarHeight
        if edge > 0 {
            return
        }
        
        avatarImg.width = self.view.width - 2 * edge
        avatarImg.height = avatarImg.width
        avatarAdjust()
    }
}

// MARK: - 用户头像
extension ProfileViewController {
    private func avatarAdjust() {
        avatarImg.centerX = view.width * 0.5
        avatarImg.centerY = view.width * 0.5
    }
}

// MARK: - Action
extension ProfileViewController {
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreButtonAction() {
        let userID = ResUser._user?.userInfo.userId
        let key = String("userBlockKey\(userID!)_\(self.userID)")
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
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func tapAvatarAction(){
        guard let imgPath = (userInfo?.imgUrl ?? userInfo?.tempStr7th) else {
            return
        }
        let browser = MRPhotoBrowser()
        browser.numberOfItems = {
            1
        }
        browser.reloadCellAtIndex = { context in
            let url = imgPath
            let browserCell = context.cell as? MRPhotoBrowserImageCell
            browserCell?.index = context.index
            
            let placeholder = self.avatarImg.image
            browserCell?.imageView.kf.setImage(with: URL(string: url ), placeholder: placeholder, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: { (_, _, _, _) in
                browserCell?.setNeedsLayout()
            })
        }
        browser.transitionAnimator = MRPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
            return self.avatarImg
        })
        browser.pageIndicator = MRPhotoBrowserNumberPageIndicator()
        browser.pageIndex = 0
        browser.show(method: .push(inNC: self.navigationController))
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
        let userID = ResUser._user?.userInfo.userId
        let key = String("userBlockKey\(userID!)_\(self.userID)")
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
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func messageButtonAction() {
        
    }
    @objc func likeButtonAction(_ sender: UIButton) {
        if sender.isSelected == true {
            return
        }
        sender.isUserInteractionEnabled = false
        sender.isSelected = true
        
    }
}
