//
//  DiscoverViewController.swift
//  MyReseau
//
//  Created by fan li on 2020/4/30.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

let kOpenMessageSuccessNotice = "kOpenMessageSuccessNotice"

class DiscoverViewController: UIViewController {
    
    var pageSize = 20
    var pageNum = 1
    var dataList = Array<UserInfo>()
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2+30)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(OmgChatCell.self, forCellWithReuseIdentifier: "OmgChatCell")
        
        collectionView.mj_header = setRefreshHeader()
        collectionView.mj_header?.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))

        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = ReseauString("Discover")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionView.mj_header?.beginRefreshing()
    }
    

    @objc private func headerRefresh() {
            pageNum = 1
            queryForData()
        }
        
        @objc private func footerRefresh() {
            pageNum += 1
            queryForData()
        }
        
        public func queryForData() {
            
            requestFireUserCollection()
            
        }
        
    private func requestFireUserCollection() {
        ReseauDB.collection(fireCollectionUserKey).getDocuments { (querySnapshot, err) in
            self.collectionView.mj_header?.endRefreshing()
            self.collectionView.mj_footer?.endRefreshing()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var items = Array<UserInfo>()
                print("start Print messages =========================================")
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let item = document.data().kj.model(UserInfo.self)
                    items.append(item)
                }
                self.dataList.removeAll()
                self.dataList = items
                self.collectionView.reloadData()
            }
        }
    }
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OmgChatCell", for: indexPath) as! OmgChatCell
        cell.setDataWithDic(dic: dataList[indexPath.row])
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let login = UserDefaults.standard.bool(forKey: "login")
        if !login {
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kPushLoginControllerNotice), object: nil)
            return
        }
        let userId = dataList[indexPath.row].firebaseUID
        let avatarImg = dataList[indexPath.row].imgUrl
        
        let vc = ProfileManager.openProfileVC(userID: dataList[indexPath.row].firebaseUID ?? "", imgUrl: fullUrlImage(url: avatarImg) ?? "")
        guard let VC = vc else {
            return
        }
        VC.fireBaseUID = userId ?? ""
        
        topVC?.navigationController?.pushViewController(VC, animated: true)
    }
    
}

class OmgChatCell: UICollectionViewCell {
    
    lazy var iconImage: UIImageView = {
        var iconImage = UIImageView()
        iconImage.layer.cornerRadius = screenWidth/4-20
        iconImage.layer.masksToBounds = true
        iconImage.layer.borderWidth = 2
        iconImage.layer.borderColor = UIColor.white.cgColor
        iconImage.contentMode = ContentMode.scaleAspectFill
        return iconImage
    }()
    
    lazy var titleView: UIView = {
        var titleView = UIView()
        return titleView
    }()
    
    lazy var titleLab: UILabel = {
        var titleLab = UILabel()
        titleLab.font = UIFont.boldSystemFont(ofSize: 18)
        titleLab.textAlignment = .center
        return titleLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(iconImage)
        iconImage.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/2-40)
            make.height.equalTo(screenWidth/2-40)
            make.top.equalTo(20)
            make.left.equalTo(20)
        }
        
        self.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(iconImage.snp_bottom)
            make.bottom.equalTo(0)
        }
        
        layoutIfNeeded()
        
        titleLab.frame = titleView.bounds
        titleView.setGradientBackgroundV()
        titleView.mask = titleLab
        self.addSubview(titleView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setDataWithDic(dic: UserInfo) {
        iconImage.kf.setImage(urlString: fullUrlImage(url: dic.imgUrl), placeholder: UIImage(named: "default_head"))
        titleLab.text = dic.nickName
    }
}
