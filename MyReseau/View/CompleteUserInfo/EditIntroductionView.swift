//
//  EditIntroductionView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/25.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class EditIntroductionView: CompleteBaseView {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var textView: UITextView!
    override func setupUI(){
        Bundle.main.loadNibNamed("EditIntroductionView", owner: self, options: nil)
        addSubview(backgroundView)
        backgroundView.frame = self.bounds
        backgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.setGradientBackground(colorOne: UIColor.hex(hexString: "#FFDF7C"),
                                          colorTwo: UIColor.hex(hexString: "#FF8D00"),
                                          startPoint: CGPoint.init(x: 0.5, y: 0),
                                          endPoint: CGPoint.init(x: 0.5, y: 1))
        

        textView.delegate = self
        textView.textColor = UIColor.hex(hexString: "#8D9498")
        super.setupUI()
    }

    @IBAction func submitAction(_ sender: Any) {
        if textView.textColor == UIColor.hex(hexString: "#8D9498") ||
        textView.text.count < 20{
            HUD.flash(.label("20 characters minimum"),delay: 1)
            return
        }
        
        super.dismiss()
        let userInfo = ResUser.user?.userInfo
        userInfo?.tempStr2nd = self.textView.text
        userInfo?.spareNum1st = 2
        ResUser.user?.save()
        ProfileManager.canOpenProfile()
        
        self.updateUserInfo()
    }
    
}

extension EditIntroductionView: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {
            textView.text = "write something..."
            textView.textColor = UIColor.hex(hexString: "#8D9498")
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }else if textView.textColor == UIColor.hex(hexString: "#8D9498") && !text.isEmpty {
            textView.textColor = UIColor.hex(hexString: "#333333")
            textView.text = text
        }else {
            return true
        }
        
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.window != nil {
            if textView.textColor == UIColor.hex(hexString: "#8D9498") {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
        if textView.text.count > 1000 {
            textView.text = String((textView.text as String).prefix(1000))
        }

    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.hex(hexString: "#8D9498") {
            textView.textColor = UIColor.hex(hexString: "#333333")
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "write something..."
            textView.textColor = UIColor.hex(hexString: "#8D9498")
        }
    }
}
