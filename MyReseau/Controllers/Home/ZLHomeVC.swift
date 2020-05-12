//
//  ZLHomeVC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/4.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import SnapKit
import PKHUD
import FirebaseAuth
import KakaJSON
class ZLHomeVC: ZLBaseVC {
    
    @IBOutlet weak var searchButton: UIButton!
    var maskView: UIView!
    var maskViewReply: UIView!
    var messageStoreList = Array<MassageInfo>()
    var messageShowList = Array<MassageInfo>()
    var cardItems = Array<CardView>()
    var messageView:MassageView?
    @IBOutlet weak var topEdge: NSLayoutConstraint!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor.hex(0x45BECA)

        autoLogin()
        setupUI()
        topEdge.constant = 167 + (screenHeight - 667) * 0.15
        
        NotificationCenter.default.addObserver(self, selector: #selector(requestObjcList), name: NSNotification.Name.init(rawValue: kLoginSuccessNotice), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if topVC?.isKind(of: ProfileViewController.self) == true {
            return
        }
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        searchButton.setGradientBackground(colorOne: UIColor.hex(hexString: "#FF686B"),
                                           colorTwo: UIColor.hex(hexString: "#FFB06C"))
        
        for i in 0 ... 4 {
            let topArea = (isIphoneX ? 44 : 20)  + (screenHeight - 667) * 0.8
            let carView = CardView(frame: CGRect.zero)
            carView.isHidden = true
            view.addSubview(carView)
            carView.snp.makeConstraints { (make) in
                switch i {
                case 0: make.top.equalTo(87 + topArea); make.centerX.equalTo(view)
                case 1: make.top.equalTo(137 + topArea); make.left.equalTo(0)
                case 2: make.top.equalTo(137 + topArea); make.right.equalTo(0)
                case 3: make.top.equalTo(260 + topArea); make.left.equalTo(33)
                case 4: make.top.equalTo(260 + topArea); make.right.equalTo(-33)
                default:break
                }
                make.width.equalTo(111)
                make.height.equalTo(77)
            }
            cardItems.append(carView)
            let button = UIButton()
            button.tag = i
            button.addTarget(self, action: #selector(cardOpendMessageAction), for: .touchUpInside)
            view.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.edges.equalTo(carView)
            }

        }
        
        maskView = UIView()
        maskView.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        view.addSubview(maskView)
        maskView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        maskView.alpha = 0
        
        maskViewReply = UIView()
        maskViewReply.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        view.addSubview(maskViewReply)
        maskViewReply.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        maskViewReply.alpha = 0
    }
    
    

    @objc func cardOpendMessageAction(_ sender:UIButton){
        if self.cardItems[sender.tag].isHidden == true {
            return
        }
        openMessage(message: self.messageShowList[sender.tag])
        UIView.animate(withDuration: 0.2, animations: {
            self.cardItems[sender.tag].transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
        }) { (finish) in
            self.cardItems[sender.tag].isHidden = true
        }
    }
    
    @IBAction func userAction(_ sender: Any) {
        let transition = CATransition();
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .default)
        transition.type = .push
        transition.subtype = .fromLeft
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(EditProfileVC(), animated: false)
    }
    
    @IBAction func setttingAction(_ sender: Any) {
        navigationController?.pushViewController(SettingVC(), animated: true)
    }
    
    @IBAction func writeAction(_ sender: Any) {
        let login = UserDefaults.standard.bool(forKey: "login")
        if !login {
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kPushLoginControllerNotice), object: nil)
            return
        }
        showWriteLetterView()
    }
    
    @IBAction func letterAction(_ sender: Any) {
        let vc = MyLetterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        adjustMessageShow(false)
    }
    
    func autoLogin(){
        guard UserDefaults.standard.object(forKey: "login") != nil else {
            return
        }
        guard let email = UserDefaults.standard.object(forKey: "email") else {
            return
        }
        guard let psw = UserDefaults.standard.object(forKey: "psw") else {
            return
        }
        
        HUD.flash(.progress,delay: 60)
        Auth.auth().signIn(withEmail:email as! String, password: psw as! String) {(result, error) in
            HUD.hide()
            UserDefaults.standard.set(true, forKey: "login")
            guard let user = result?.user, error == nil else{
                HUD.hide()
                return
            }
            
            ReseauUser = user
            ResUser.user?.userInfo.firebaseUID = user.uid
            ReseauDB.collection(fireCollectionUserKey).document(user.uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    let user = dataDescription?.kj.model(UserInfo.self)
                    user?.firebaseUID = ReseauUser?.uid
                    let omguser = ResUser.user
                    omguser?.userInfo = user ?? UserInfo()
                    omguser?.save()
                    HUD.hide()
                } else {
                    HUD.hide()
                }
            }
            self.getFireStoreData()
        }
    }
    
    private func showWriteLetterView(){
        let letterView = WriteLetterView.init(frame: CGRect.init(x: 0, y: self.view.height, width: self.view.width, height: 542))
        self.view.addSubview(letterView)
        UIView.animate(withDuration: 0.2) {
            letterView.y = self.view.height - letterView.height
            self.maskView.alpha = 1
        }
        letterView.backClosure = {
            UIView.animate(withDuration: 0.1) {
                self.maskView.alpha = 0
            }
        }
    }
    
    @objc func requestObjcList() {
        getFireStoreData()
    }
    
    private func getFireStoreData() {
        HUD.flash(.progress,delay: 60)
        ReseauDB.collection(fireCollectionMessageKey).getDocuments { (querySnapshot, err) in
            
            HUD.hide()
            if let err = err {
                HUD.flash(.label(err.localizedDescription), delay: 1)
                print("Error getting documents: \(err)")
            } else {
                var items = Array<MassageInfo>()
                print("start Print messages =========================================")
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let item = document.data().kj.model(MassageInfo.self)
                    items.append(item)
                }
                
                self.messageStoreList.removeAll()
                self.messageStoreList = items
            }
        }
    }
    

// MARK: - private
    private func hiddenAllCard(){
        for card in cardItems {
            card.isHidden = true
        }
    }
    
    private func adjustMessageShow(_ isFirst: Bool){
        hiddenAllCard()
        messageShowList.removeAll()
        if messageStoreList.count == 0 {
//            requestMessageList()
            getFireStoreData()
        }else if messageStoreList.count < 5 {
            messageShowList = messageStoreList
            messageStoreList.removeAll()
        }else{
            messageShowList = Array(messageStoreList[0...4])
            messageStoreList.removeSubrange(0...4)
        }
        for i in 0 ..< messageShowList.count {
            cardItems[i].isHidden = false
            cardItems[i].avatar.kf.setImage(urlString: fullUrlImage(url: messageShowList[i].userInfo?.imgUrl),
                                            placeholder: UIImage.init(named: "default_head"))
            if isFirst {
                self.cardItems[i].transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                UIView.animate(withDuration: 0.2, animations: {
                    self.cardItems[i].transform = CGAffineTransform.init(scaleX: 1, y: 1)
                }) { (finish) in
                    
                }
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.cardItems[i].transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                }) { (finish) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.cardItems[i].transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    }) { (finish) in
                        
                    }
                }
            }
        }
    }
    
    private func openMessage(message: MassageInfo){
        guard let messageID = message.id else{
            return
        }
        let login = UserDefaults.standard.bool(forKey: "login")
        if login {
            do {
                let messageCopy = message
                messageCopy.openMessageUID = ReseauUser?.uid
                let encoder = JSONEncoder()
                let data = try encoder.encode(message)
                print("struct convert to data")
                let msgDic = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let documentID = String("\((ReseauUser?.uid ?? ""))\(String(messageID))")
                ReseauDB.collection(fireCollectionMsgOpenKey).document(documentID).setData(msgDic as! [String : Any])
                print(msgDic)
            } catch {
                print(error)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kOpenMessageSuccessNotice), object: nil)
        let messageView : MassageView = MassageView.init(frame: CGRect.zero)
        messageView.alpha = 0
        view.addSubview(messageView)
        messageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(313)
            make.height.equalTo(341)
        }
        self.messageView = messageView
        guard let userInfo = message.userInfo else {
            return
        }
        var city = ""
        if let tmp = userInfo.city , tmp.count > 0{
            city = tmp
        }else if let tmp = userInfo.province , tmp.count > 0{
            city = tmp
        }else if let tmp = userInfo.country , tmp.count > 0{
            city = tmp
        }
        let title = String("A letter from \(city)")
        messageView.updateModel(title: title, content: message.content ?? "", avatar:userInfo.imgUrl)
        UIView.animate(withDuration: 0.2) {
            messageView.alpha = 1
            self.maskView.alpha = 1
        }
        
        messageView.keepActClosure = {[weak self] in
            UIView.animate(withDuration: 0.1) {
                self?.maskView.alpha = 0
            }
            let vc = CommentsTableViewController()
            vc.fireDBID = message.fireDBID
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        messageView.replyActClosure = {[weak self] in
            self?.openReplyView(message: message)
        }
        messageView.reportClosure = {[weak self] in
            UIView.animate(withDuration: 0.1) {
                self?.maskView.alpha = 0
            }
            
       }
    }
    
    private func reportAction(_ bottleID: Int, userID: Int){
        let login = UserDefaults.standard.bool(forKey: "login")
        if !login {
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kPushLoginControllerNotice), object: nil)
            return
        }
        
        let alertVC = UIAlertController.init()
        let cancelAlert = UIAlertAction.init(title: "Cancel", style: .cancel) { (_) in}
        let reportAlert = UIAlertAction.init(title: "Report", style: .default) { (_) in
            
        }
        reportAlert.setValue(UIColor.hex(hexString: "1E1E1E"), forKey: "titleTextColor")
        let blockAlert = UIAlertAction.init(title: "Block", style: .default) { (_) in
        }
        let deleteAlert = UIAlertAction.init(title: "Remove", style: .default) { (_) in
        }
        blockAlert.setValue(UIColor.hex(hexString: "1E1E1E"), forKey: "titleTextColor")
        deleteAlert.setValue(UIColor.hex(hexString: "1E1E1E"), forKey: "titleTextColor")
        cancelAlert.setValue(UIColor.hex(hexString: "FF696B"), forKey: "titleTextColor")
        alertVC.addAction(reportAlert)
        alertVC.addAction(blockAlert)
        alertVC.addAction(deleteAlert)
        alertVC.addAction(cancelAlert)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func openReplyView(message: MassageInfo){
        self.view.bringSubviewToFront(maskViewReply)
        let replyView : ReplyMessageView = ReplyMessageView.init(frame: CGRect.init(x: 0, y: self.view.height, width: self.view.width, height: 509))
        self.view.addSubview(replyView)
        replyView.messageID = message.id
        UIView.animate(withDuration: 0.1) {
            replyView.y = self.view.height - replyView.height
            self.maskViewReply.alpha = 1
        }
        replyView.backClosure = {
            UIView.animate(withDuration: 0.1) {
                self.maskViewReply.alpha = 0
            }
        }
        replyView.commentClosure = { comment in
            let messageCopy = message
            let item = CommentsInfo()
            item.content = comment
            item.userInfo = ResUser.user?.userInfo
            messageCopy.commentList.append(item)
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(messageCopy)
                print("struct convert to data")

                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                ReseauDB.collection(fireCollectionMessageKey).document(message.fireDBID ?? "").setData(dict as! [String : Any])
            } catch {
                print(error)
            }
        }
    }
}

class CardView: UIImageView {
    
    let avatar: UIImageView = UIImageView()
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        image = UIImage.init(named: "bottleandwording")
        
        addSubview(avatar)
        avatar.layer.cornerRadius = 15.5
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        avatar.image = UIImage.init(named: "default_head")
        avatar.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(2)
            make.width.height.equalTo(31)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
