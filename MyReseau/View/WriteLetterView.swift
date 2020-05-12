//
//  WriteLetterView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/9.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD
class WriteLetterView: UIView {

    var backClosure: ButtonActionClosure?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI(){
        Bundle.main.loadNibNamed("WriteLetterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sendButton.setGradientBackground(colorOne: UIColor.hex(hexString: "#FF686B"),
                                         colorTwo: UIColor.hex(hexString: "#FFB06C"),
                                         startPoint: CGPoint(x: 0, y: 0),
                                         endPoint: CGPoint(x: 1, y: 0))
        
        let maskPath = UIBezierPath.init(roundedRect: self.bounds,
                                         byRoundingCorners: [.topLeft, .topRight],
                                         cornerRadii: CGSize.init(width: 15, height: 15))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        baseView.layer.mask = maskLayer
        let url = ResUser.user?.userInfo.tempStr7th ?? ResUser.user?.userInfo.imgUrl
        avatarImg.kf.setImage(urlString: fullUrlImage(url: url), placeholder: UIImage.init(named: "default_head"))
        contentTextView.delegate = self
        contentTextView.textColor = UIColor.hex(hexString: "#999999")
    }
    
    
    @IBAction func sendButtonAction(_ sender: Any) {
        guard let content = contentTextView.text,
            contentTextView.textColor != UIColor.hex(hexString: "#999999"),
            content.count > 0, content.replacingOccurrences(of: " ", with: "").count > 0  else {
            HUD.flash(.label("writen something"))
            return
        }

        HUD.flash(.progress,delay: 60)
        let message = MassageInfo()
        message.content = content
        message.id = Int(Date().millisecondsSince1970) + AnyStringToInt(str: ReseauUser?.uid ?? "temp")
        message.fireDBID = String("\(Date().millisecondsSince1970)\(ReseauUser?.uid ?? "temp")")
        message.imgUrl = ReseauUser?.photoURL?.absoluteString
        message.userInfo = ResUser.user?.userInfo
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(message)
            print("struct convert to data")

            let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            ReseauDB.collection(fireCollectionMessageKey).document(String("\(message.fireDBID ?? String(Date().millisecondsSince1970))")).setData(dict as! [String : Any]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                    HUD.hide()
                } else {
                    self.dimissReplyView()
                    HUD.flash(.label("send success"))
                }
            }
            print(dict)

        } catch {
            print(error)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dimissReplyView()
    }
    
    private func dimissReplyView(){
        UIView.animate(withDuration: 0.1, animations: {
            self.y = screenHeight
        }) { (finish) in
            self.removeFromSuperview()
        }
        guard let closure = backClosure else { return }
        closure()
    }
    
}

extension WriteLetterView: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {
            textView.text = ReseauString("Write down interesting things")
            textView.textColor = UIColor.hex(hexString: "#999999")
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }else if textView.textColor == UIColor.hex(hexString: "#999999") && !text.isEmpty {
            textView.textColor = UIColor.hex(hexString: "#333333")
            textView.text = text
        }else {
            return true
        }
        
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.window != nil {
            if textView.textColor == UIColor.hex(hexString: "#999999") {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
        if textView.text.count > 500 {
            textView.text = String((textView.text as String).prefix(500))
        }
        self.countLabel.text = String("\(textView.text.count)/500")
    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.hex(hexString: "#999999") {
            textView.textColor = UIColor.hex(hexString: "#333333")
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ReseauString("Write down interesting things")
            textView.textColor = UIColor.hex(hexString: "#999999")
        }
    }
}
