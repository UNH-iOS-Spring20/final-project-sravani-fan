//
//  ZLBaseVC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/3.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class ZLBaseVC: UIViewController,UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let item = UIBarButtonItem()
        item.title = ""
        navigationItem.backBarButtonItem = item
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
  

}
