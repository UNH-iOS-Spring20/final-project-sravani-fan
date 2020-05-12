//
//  ReplyMessageView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/9.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import PKHUD

typealias CommentActionClosure = (_ comment: String)->Void

class ReplyMessageView: UIView {

    var backClosure: ButtonActionClosure?
    var commentClosure: CommentActionClosure?
    @IBOutlet var contentView: UIView!
    var messageID: Int?
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var textCountLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI(){
        Bundle.main.loadNibNamed("ReplyMessageView", owner: self, options: nil)
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
        self.layer.mask = maskLayer
        
        contentTextView.delegate = self
        contentTextView.textColor = UIColor.hex(hexString: "#999999")
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
    
// MARK: - Action
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dimissReplyView()
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        guard contentTextView.text != nil else {
            HUD.flash(.label("Write something"))
            return
        }
        guard let closure = commentClosure else { return }
        closure(contentTextView.text)
        self.dimissReplyView()
        

    }
    
    
}


extension ReplyMessageView: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {
            textView.text = ReseauString("What do you want to say to others?")
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
        if textView.text.count > 1000 {
            textView.text = String((textView.text as String).prefix(1000))
        }
        self.textCountLabel.text = String("\(textView.text.count)/1000")
    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.hex(hexString: "#999999") {
            textView.textColor = UIColor.hex(hexString: "#333333")
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ReseauString("What do you want to say to others?") 
            textView.textColor = UIColor.hex(hexString: "#999999")
        }
    }
}
