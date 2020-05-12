//
//  MassageView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/9.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import Kingfisher

typealias ButtonActionClosure = ()->Void

class MassageView: UIView {
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var keepBtn: UIButton!
    
    @IBOutlet weak var closeBtn: UIButton!
    var replyActClosure: ButtonActionClosure?
    var keepActClosure: ButtonActionClosure?
    var reportClosure: ButtonActionClosure?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI(){
        Bundle.main.loadNibNamed("MassageView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        replyBtn.setGradientBackground(colorOne: UIColor.hex(hexString: "#FF686B"),
                                       colorTwo: UIColor.hex(hexString: "#FFB06C"),
                                       startPoint: CGPoint(x: 0, y: 0),
                                       endPoint: CGPoint(x: 1, y: 0))
        titleLabel.text = "A letter from New York"
        keepBtn.layer.borderColor = UIColor.hex(hexString: "#FF6D6B").cgColor
        closeBtn.tintColor = UIColor.hex(hexString: "#FF6D6B")

    }

    
    func updateModel(title:String, content:String, avatar:String?) {
        titleLabel.text = title
        contentTextView.text = content
        avatarImg.kf.setImage(urlString: fullUrlImage(url: avatar), placeholder: UIImage.init(named: "default_head"))
    }
    
    @IBAction func reportButton(_ sender: Any) {
        
        guard let closure = reportClosure else { return }
        closure()
        closeMessageView()
    }
    
    @IBAction func keepButton(_ sender: Any) {
        guard let closure = keepActClosure else { return }
        closure()
        closeMessageView()
    }
    
    @IBAction func replyButtonAction(_ sender: Any) {
        guard let closure = replyActClosure else { return }
        closure()
    }
    
    func closeMessageView(){
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
