//
//  MyLetterViewController.swift
//  MyReseau
//
//  Created by fan li on 2020/4/10.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import MJRefresh
import SnapKit
class MyLetterViewController: ZLBaseVC {
    
    var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    var items = Array<MassageInfo>()
    var page = 0
    var maskView: UIView!
    var maskViewReply: UIView!
    var messageView:MassageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ReseauString("My Letter")
        emptyView.isHidden = true
        setupUI()
        collectionView.isHidden = true
        collectionView.mj_footer?.beginRefreshing()
        
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(requestList), name: NSNotification.Name.init(rawValue: kOpenMessageSuccessNotice), object: nil)
    }


    private func setupUI(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 0;
        let width = (screenWidth - (20 * 3)) * 0.5
        layout.itemSize = CGSize.init(width: width, height: 209)
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.hex(hexString: "#F3F3F3")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LetterCell.self, forCellWithReuseIdentifier: "LetterCellIdentifier")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        collectionView.mj_header = setRefreshHeader()
        collectionView.mj_header?.setRefreshingTarget(self, refreshingAction: #selector(requestList))
    }
    
    private func requestFireStoreData() {
        guard UserDefaults.standard.object(forKey: "login") != nil else {
            return
        }
        ReseauDB.collection(fireCollectionMsgOpenKey).whereField("openMessageUID", isEqualTo: ReseauUser?.uid ?? "")
            .getDocuments() { (querySnapshot, err) in
                self.collectionView.mj_footer?.endRefreshing()
                self.collectionView.mj_header?.endRefreshing()
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var items = Array<MassageInfo>()
                    print("start Print messages =========================================")
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let item = document.data().kj.model(MassageInfo.self)
                        items.append(item)
                    }
                    
                    self.items = items
                    if self.items.count == 0{
                        self.emptyView.isHidden = false
                        self.collectionView.isHidden = true
                        self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                    }else{
                        self.emptyView.isHidden = true
                        self.collectionView.isHidden = false
                    }
                    self.collectionView.reloadData()
                }
        }
    }
    
    @objc private func requestList(){
        requestFireStoreData()
        
        
    }
}

extension MyLetterViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCellIdentifier", for: indexPath) as! LetterCell
        cell.updateModel(model: items[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openMessage(message: items[indexPath.row])
    }

    private func openMessage(message: MassageInfo){
        guard message.id != nil else{
            return
        }
        
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
    
    private func reportAction(_ messageID: Int, userID: Int){
        
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


class LetterCell: UICollectionViewCell {
    
    let avatar = UIImageView()
    let content = UILabel()
    var avatarImg: String?
    var userID: String?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.hex(hexString: "#F3F3F3")
        
        let baseView = UIView()
        baseView.backgroundColor = .white
        baseView.layer.cornerRadius = 15
        contentView.addSubview(baseView)
        baseView.snp.makeConstraints { (make) in
            make.top.equalTo(49)
            make.bottom.left.right.equalTo(contentView)
//            make.height.equalTo(170)
        }
        
        let avatarView = UIView()
        avatarView.backgroundColor = .white
        avatarView.layer.cornerRadius = 40
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(baseView.snp_top)
            make.width.height.equalTo(80)
        }
        
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 37.5
        avatar.contentMode = .scaleAspectFill
        contentView.addSubview(avatar)
        avatar.snp.makeConstraints { (make) in
            make.center.equalTo(avatarView)
            make.width.height.equalTo(75)
        }
        avatar.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAvatarAction(_:)))
        avatar.addGestureRecognizer(tap)
        
        content.textColor = UIColor.hex(hexString: "#1E1E1E")
        content.font = UIFont.systemFont(ofSize: 12)
        content.numberOfLines = 6
        contentView.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(avatar.snp_bottom).offset(14)
        }
    }
    
    func updateModel(model: MassageInfo){
        avatar.kf.setImage(urlString: fullUrlImage(url: model.userInfo?.imgUrl), placeholder: UIImage.init(named: "default_head"))
        content.text = model.content
        avatarImg = model.userInfo?.imgUrl
        userID = model.userInfo?.firebaseUID
    }
    
    @objc func tapAvatarAction(_ sender: UIButton) {
        let vc = ProfileManager.openProfileVC(userID: "", imgUrl: fullUrlImage(url: avatarImg) ?? "")
        guard let VC = vc else {
            return
        }
//        VC.userID = userID ?? 0
        VC.fireBaseUID = userID ?? ""
        topVC?.navigationController?.pushViewController(VC, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

