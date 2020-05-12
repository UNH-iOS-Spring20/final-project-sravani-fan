//
//  ChooseHeightView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/25.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class ChooseHeightView: CompleteBaseView {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    let items = ["5' 0\" (152 cm)","5' 1\" (155 cm)","5' 2\" (157 cm)","5' 3\" (160 cm)","5' 4\" (163 cm)","5' 5\" (165 cm)","5' 6\" (168 cm)","5' 7\" (170 cm)","5' 8\" (173 cm)","5' 9\" (175 cm)","5' 10\" (178 cm)","5' 11\" (180 cm)","6' 1\" (183 cm)","6' 2\" (185 cm)","6' 3\" (188 cm)","6' 4\" (190 cm)","6' 5\" (193 cm)","6' 6\" (196 cm)","6' 7\" (198 cm)","6' 8\" (201 cm)","6' 9\" (203 cm)","6' 10\" (206 cm)","6' 11\" (211 cm)"]
    lazy var collectionView : UICollectionView = {
        let layout = LCYSearchFlowLayout()
        layout.minimumLineSpacing = 9
        layout.minimumInteritemSpacing = 12
        layout.itemSize = CGSize(width: 102, height: 35)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func setupUI(){
        Bundle.main.loadNibNamed("ChooseHeightView", owner: self, options: nil)
        addSubview(backgroundView)
        backgroundView.frame = self.bounds
        backgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.setGradientBackground(colorOne: UIColor.hex(hexString: "#FFDF7C"),
                                          colorTwo: UIColor.hex(hexString: "#FF8D00"),
                                          startPoint: CGPoint.init(x: 0.5, y: 0),
                                          endPoint: CGPoint.init(x: 0.5, y: 1))
        
        collectionView.register(ChooseHeigtCell.self, forCellWithReuseIdentifier: "ChooseHeigtCellKey")
        contentView.addSubview(collectionView)
        collectionView.snp_makeConstraints({ (make) in
            make.top.equalTo(125)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-30)
        })
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        super.setupUI()
    }
}


extension ChooseHeightView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ChooseHeigtCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseHeigtCellKey", for: indexPath) as! ChooseHeigtCell
        cell.content.text = items[indexPath.row]
        cell.content.font = UIFont.systemFont(ofSize: 13)
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
        userInfo?.spareStr1st = self.items[indexPath.row]
        ResUser.user?.save()
        ProfileManager.canOpenProfile()
        
        self.updateUserInfo()
    }
    
    
}


class ChooseHeigtCell: UICollectionViewCell {
    let content = UILabel()
    
    var isChoice:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        content.textColor = .white
        content.font = UIFont.systemFont(ofSize: 15)
        content.textAlignment = .center
        contentView.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        content.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        
        content.layer.cornerRadius = self.height * 0.5
        content.clipsToBounds = true
    }
    
    func setupCellHightlight(){
        self.content.textColor = UIColor.hex(0xFF686B)
        self.content.backgroundColor = UIColor.white
    }
    
    func setupCellunHightlight(){
        self.content.textColor = UIColor.white
        self.content.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
    }
    
    func updateCellStatus(_ status: Bool){
        isChoice = status
        content.textColor = (status == true) ? UIColor.hex(hexString: "#F99148") : .white
        content.backgroundColor = (status == true) ? .white : UIColor.init(white: 0, alpha: 0.2)
    }
    
    func swipChoiceStatus() {
        isChoice = !isChoice
        updateCellStatus(isChoice)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
