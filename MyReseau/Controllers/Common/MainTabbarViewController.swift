//
//  MainTabbarViewController.swift
//  APP
//
//  Created by fan li on 2020/4/3.
//  Copyright © 2020 Psycho. All rights reserved.
//

import UIKit
let kPushLoginControllerNotice = "kPushLoginControllerNotice"
class MainTabbarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        tabBar.backgroundColor = UIColor.white
        
    
        addChildViewControllers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushLoginView), name: NSNotification.Name.init(rawValue: kPushLoginControllerNotice), object: nil)
    }
    
    func addChildViewControllers() {
        let homeVC = ZLHomeVC.init()
        let homeNav = ZLNavigationVC.init(rootViewController: homeVC)
        addChildrenViewController(homeNav, ReseauString("Home"), "tabbar_home", "tabbar_homeSel")
        
        let squareVC = DiscoverViewController.init()
        let squareNav = ZLNavigationVC.init(rootViewController: squareVC)
        addChildrenViewController(squareNav, ReseauString("Discover"), "tabbar_discover", "tabbar_discoverSel")
        
        let publishVC = MyLetterViewController.init()
        let publishNav = ZLNavigationVC.init(rootViewController: publishVC)
        addChildrenViewController(publishNav, ReseauString("My Letter"), "tabbar_letter", "tabbar_letterSel")
        
        let userVC = EditProfileVC.init()
        let userNav = ZLNavigationVC.init(rootViewController: userVC)
        addChildrenViewController(userNav, ReseauString("Profile"), "tabbar_user", "tabbar_userSel")
    }

    func addChildrenViewController(_ childVC: UIViewController, _ title: String, _ img: String, _ imgSel: String) {
        childVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)],
                                                  for: .normal)
        childVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.hex(hexString: "#FF696B"), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)],
        for: .selected)
        
        childVC.tabBarItem.image = UIImage.init(named: img)
        let selectImage = UIImage.init(named: imgSel)
        childVC.tabBarItem.selectedImage = selectImage
        childVC.tabBarItem.title = title
        
        addChild(childVC)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if UserDefaults.standard.bool(forKey: "login") {
            return true
        }
        let nav:ZLNavigationVC = viewController as! ZLNavigationVC
        if nav.viewControllers.first?.isKind(of: MyLetterViewController.self) == true ||
           nav.viewControllers.first?.isKind(of: EditProfileVC.self) == true {
            pushLoginView()
            return false
        }
        return true
    }
    
    
    @objc func pushLoginView() {
        self.selectedIndex = 0
        let nav = ZLNavigationVC(rootViewController: ZLLaunchVC())
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
