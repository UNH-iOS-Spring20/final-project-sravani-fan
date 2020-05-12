//
//  ChooseOccupationView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/25.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class ChooseOccupationView: CompleteBaseView {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    let items = ["Student","Teacher","Model","Artistic","Musical","Writer","Fashion",
    "Actor","Secretarial","Administrative","Design","Management","Civil Service","Self Employed","Entrepreneur","Sales","Marketing","Retired","inance","Investor","Accounting","Technical","Science","Engineering","Other"]
    lazy var collectionView : UICollectionView = {
        let layout = LCYSearchFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 9
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func setupUI(){
        Bundle.main.loadNibNamed("ChooseOccupationView", owner: self, options: nil)
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
            make.top.equalTo(105)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-30)
        })
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        super.setupUI()
    }
}

extension ChooseOccupationView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont.systemFont(ofSize: 15)
        let rect = NSString(string: items[indexPath.row]).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 35), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return CGSize.init(width: rect.width + 24, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.dismiss()
        let userInfo = ResUser.user?.userInfo
        userInfo?.spareStr8th = self.items[indexPath.row]
        ResUser.user?.save()
        ProfileManager.canOpenProfile()
        
        self.updateUserInfo()
    }
    
}
