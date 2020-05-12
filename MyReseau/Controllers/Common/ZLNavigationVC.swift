//
//  ZLNavigationVC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/3.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class ZLNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(gradientColors: [UIColor(red: 0.99, green: 0.87, blue: 0.6, alpha: 1), UIColor(red: 1, green: 0.41, blue: 0.42, alpha: 1), UIColor(red: 1, green: 0.69, blue: 0.42, alpha: 1)], size: CGSize(width: UIScreen.main.bounds.width, height: 20), startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        self.navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white]
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "lefterbackicon_titlebar_24x24_"), style: .plain, target: self, action: #selector(navigationBack))
        }
        super.pushViewController(viewController, animated: true)
    }
    
    
    @objc private func navigationBack() {
        popViewController(animated: true)
    }
 

}
