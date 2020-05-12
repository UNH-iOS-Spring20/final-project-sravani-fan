//
//  Global.swift
//  U17
//
//  Created by fan li on 2017/10/24.
//  Copyright © 2017年 None. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit
import PKHUD
import MJRefresh
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
var ReseauUser: User?

let clientNum = 1
let appType = 1

let ReseauDB = Firestore.firestore()
let ReseauStorageRef = Storage.storage().reference()

let fireCollectionMessageKey = "messages"
let fireCollectionUserKey = "users"
let fireCollectionMsgOpenKey = "msgOpen"

let adminParam : [String:Any] = ["email":"1088@163.com",
         "password": "123456",
         "type":"email",
         "username":"admin",
         "clientNum":"60000",
         "appType":"100",
         "gender":1
]

func AnyStringToInt(str:String) -> Int{
    guard str.isEmpty == false else {
        print("string cannot be nil");
        return 0;
    }

    var s = String()
    for characterInt in str.unicodeScalars {
        var tempStrInt = characterInt.value  - "0".unicodeScalars.first!.value
        if tempStrInt > 9 {
            tempStrInt = tempStrInt % 9
        }
        s.append(contentsOf: String(tempStrInt))
    }
    return Int(s) ?? 0;
}

func fullUrlImage(url: String?) -> String? {
   
    return url
}

func ReseauString(_ key: String) -> String{
    return NSLocalizedString(key, comment: "")
}



let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let statusBarHeight = UIApplication.shared.statusBarFrame.height

var topVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}

var isIphoneX: Bool {
    return UI_USER_INTERFACE_IDIOM() == .phone
        && (max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 812
        || max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 896)
}

private  func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}


func uLog<T>(_ message: T, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message)")
    #endif
}

extension Kingfisher where Base: ImageView {
    @discardableResult
    public func setImage(urlString: String?, placeholder: Placeholder? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""),
                        placeholder: placeholder,
                        options:[.transition(.fade(0.5))])
    }
}

extension Kingfisher where Base: UIButton {
    @discardableResult
    public func setImage(urlString: String?, for state: UIControl.State, placeholder: UIImage? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""),
                        for: state,
                        placeholder: placeholder,
                        options: [.transition(.fade(0.5))])
        
    }
    @discardableResult
    public func setBackgroundImage(urlString: String?, for state: UIControl.State, placeholder: UIImage? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
        return setBackgroundImage(with: URL(string: urlString ?? ""),
                                  for: state,
                                  placeholder: placeholder,
                                  options: [.transition(.fade(0.5))])
    }
}



extension ConstraintView {
    
    var usnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        } else {
            return self.snp
        }
    }
}

extension UICollectionView {
    
    func reloadData(animation: Bool = true) {
        if animation {
            reloadData()
        } else {
            UIView .performWithoutAnimation {
                reloadData()
            }
        }
    }
}


//MARK: refresh header & footer

func setRefreshHeader() -> MJRefreshNormalHeader {
    let header = MJRefreshNormalHeader()
    header.setTitle("", for: MJRefreshState.idle)
    header.setTitle("", for: MJRefreshState.noMoreData)
    header.setTitle("", for: MJRefreshState.pulling)
    header.setTitle("", for: MJRefreshState.refreshing)
    header.setTitle("", for: MJRefreshState.willRefresh)
    header.lastUpdatedTimeLabel?.isHidden = true
    header.stateLabel?.isHidden = true
    return header
}

func setRefreshFooter() -> MJRefreshAutoFooter {
    let footer = MJRefreshAutoNormalFooter()
    footer.setTitle("", for: MJRefreshState.idle)
    footer.setTitle("", for: MJRefreshState.noMoreData)
    footer.setTitle("", for: MJRefreshState.pulling)
    footer.setTitle("", for: MJRefreshState.refreshing)
    footer.setTitle("", for: MJRefreshState.willRefresh)
    footer.isRefreshingTitleHidden = true
    return footer
}
