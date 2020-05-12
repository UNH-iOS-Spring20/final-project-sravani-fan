//
//  ZLLocationSelectVC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/15.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import SnapKit
import PKHUD
import KakaJSON
class ZLLocationSelectVC: ZLBaseVC,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    lazy var collectionView : UICollectionView = {
        let layout = LCYSearchFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = CGSize(width: 80, height: 20)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(hex: 0xf3f3f3)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var datas : [Character:[OptionData]] = [:]
    var titles : [Character] = []
    var selectedStr : String?
    var complete : (([OptionData])->())?
    var type:Int = 1
    let titleConfig = ["","Contry","State","City"]
    var selectResult : [OptionData] = []
    
    init(datas:[Character:[OptionData]]?,type:Int) {
        super.init(nibName: nil, bundle: nil)
        self.datas = datas ?? [:]
        self.type = type
        self.titles = datas?.keys.sorted() ?? []
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp_makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        collectionView.register(ZLTagCell.self, forCellWithReuseIdentifier: "ZLTagCell")
        collectionView.register(ZLTagHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ZLTagHeader")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        title = titleConfig[type]
        if titles.count == 0 {
            fetchDatas()
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datas[titles[section]]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ZLTagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZLTagCell", for: indexPath) as! ZLTagCell
        let location = datas[titles[indexPath.section]]![indexPath.row]
        cell.lbl.text = location.name;
        cell.isSelectedState = location.name==selectedStr
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let location = datas[titles[indexPath.section]]![indexPath.row]
        selectedStr = location.name
        collectionView.reloadData()
        fetchDatas(code: nil, id: location.id,type: self.type+1) { (children) in
            self.didFetchedChildren(children: children, location: location)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header : ZLTagHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ZLTagHeader", for: indexPath) as! ZLTagHeader
        header.lbl.text = String(titles[indexPath.section])
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 45)
    }
    
    private func convertToDictWithData(datas:[OptionData]) -> [Character:[OptionData]] {
        var result : [Character:[OptionData]] = [:]
        for data in datas {
            let capital = data.name?.first!
            var array = result[capital!] ?? []
            array.append(data)
            result[capital!] = array
        }
        return result
    }
    func fetchDatas() {
        fetchDatas(code: nil, id: nil, type: self.type) { (datas) in
            self.datas = datas
            self.titles = datas.keys.sorted()
            self.collectionView.reloadData()
        }
        
    }

    private func fetchDatas(code:String?,id:Int?,type:Int?,complte:@escaping([Character:[OptionData]])->Void) {
        
        if type != 1 {
            complte([Character:[OptionData]]())
            return
        }
        
        let diaryList:String = Bundle.main.path(forResource: "location", ofType:"plist")!
        let data:NSArray = NSArray(contentsOfFile:diaryList)!
        let locationArray = data.kj.modelArray(Location.self)
        let datas = self.convertToDictWithData(datas: locationArray )
        complte(datas)
    }
    
    private func didFetchedChildren(children:[Character:[OptionData]],location:OptionData) {
        if selectResult.count == type {
            selectResult[selectResult.count-1] = location
        } else if selectResult.count < type {
            selectResult.append(location)
        } else if selectResult.count > type {
            selectResult.removeLast(type-selectResult.count)
            selectResult[selectResult.count-1] = location
        }
        if children.keys.count == 0 {
            complete?(selectResult)
            navigationController?.popToViewController((navigationController?.viewControllers[(navigationController?.viewControllers.count)!-type-1])!, animated: true)
        } else {
            let vc = ZLLocationSelectVC(datas: children, type: type+1)
            vc.selectResult = self.selectResult
            vc.complete = complete
            navigationController?.pushViewController(vc, animated: true)
        }

    }
}
