//
//  ChooseEducationView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/25.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class ChooseEducationView: CompleteBaseView {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    let items = ["High school","Some college","Current college student","Associate's / 2-Year Degree","Bachelor's / 4-Year Degree","Current grad school student","Graduate / Master's Degree","PhD. / Post Doctoral","Other"]
    lazy var collectionView : UICollectionView = {
        let layout = LCYSearchFlowLayout()
        layout.minimumLineSpacing = 9
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 212, height: 35)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    override func setupUI(){
        Bundle.main.loadNibNamed("ChooseEducationView", owner: self, options: nil)
        addSubview(backgroundView)
        backgroundView.frame = self.bounds
        backgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.setGradientBackground(colorOne: UIColor.hex(hexString: "#FFDF7C"),
                                          colorTwo: UIColor.hex(hexString: "#FF8D00"),
                                          startPoint: CGPoint.init(x: 0.5, y: 0),
                                          endPoint: CGPoint.init(x: 0.5, y: 1))
        
        collectionView.register(ChooseHeigtCell.self, forCellWithReuseIdentifier: "ChooseHeigtCell")
        contentView.addSubview(collectionView)
        collectionView.snp_makeConstraints({ (make) in
            make.top.equalTo(125)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-30)
        })
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 70)
        super.setupUI()
    }
}

extension ChooseEducationView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ChooseHeigtCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseHeigtCell", for: indexPath) as! ChooseHeigtCell
        cell.content.text = items[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell:ChooseHeigtCell = collectionView.cellForItem(at: indexPath) as! ChooseHeigtCell
        cell.setupCellHightlight()
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell:ChooseHeigtCell = collectionView.cellForItem(at: indexPath) as! ChooseHeigtCell
        cell.setupCellunHightlight()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.dismiss()
        
        let userInfo = ResUser.user?.userInfo
        userInfo?.spareStr9th = self.items[indexPath.row]
        ResUser.user?.save()
        ProfileManager.canOpenProfile()
        
        self.updateUserInfo()
    }
    
}
