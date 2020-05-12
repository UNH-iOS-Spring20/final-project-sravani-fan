//
//  ZLWebVC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/11.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import WebKit

class ZLWebVC: ZLBaseVC,WKNavigationDelegate {
    
    var URL : URL?

    lazy private var webView : WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    init(URL:URL) {
        super.init(nibName: nil, bundle: nil)
        self.URL = URL
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.navigationDelegate = self;
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if URL != nil {
            webView.load(URLRequest(url: URL!))
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            if title == nil {
                title = (object as AnyObject).title
            }
            return
        }
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        HUD.show(.progress)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HUD.hide()
    }
}
