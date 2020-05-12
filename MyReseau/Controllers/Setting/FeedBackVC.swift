//
//  FeedBackVC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/19.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
@_exported import ApplyStyleKit
@_exported import IQKeyboardManagerSwift
@_exported import PKHUD

class FeedBackVC: ZLBaseVC,TZImagePickerControllerDelegate {
    
    private var btnTakePhoto : UIButton?
    private var imgs : [String] = ["","",""]
    private var addImage = UIImage(named: "add_photo")!
    
    private var tvContent : IQTextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    @objc private func actionOnTakePhoto(sender:UIButton) {
        btnTakePhoto = sender
        btnTakePhoto!.imageView?.contentMode = .scaleAspectFill
        let imgPicker = ImagePickerVC(delegate: self, maxImagesCount: 1, columnNumber: 4, pushPhotoPickerVc: false)
        imgPicker.allowTakePicture = false
        imgPicker.allowCrop = false
        imgPicker.allowPickingVideo = false
        imgPicker.modalPresentationStyle = .fullScreen
        present(imgPicker, animated: true, completion: nil)
    }
    
 func imagePickerController(_ picker: TZImagePickerController, didFinishPicking photos: [UIImage], sourceAssets: [PHAsset], isSelectOriginalPhoto: Bool, infos: [Dictionary<String, Any>]?) {
     let img = photos.first!
     btnTakePhoto!.setImage(img, for: .normal)
 }

    
    @objc private func actionOnSubmit(sender:UIButton) {
    
    }
        
    //MARK:- Private Method
    private func configUI() {
        title = "Feedback"
        view.backgroundColor = UIColor(hex: 0xf3f3f3)
        let scrollView = UIScrollView()
        scrollView.delaysContentTouches = true
        view.addSubview(scrollView)
        
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        let labelTitle = UILabel()
        labelTitle.applyStyle.text("Content").font(UIFont(name: "ArialMT", size: 16)!)
        scrollView.addSubview(labelTitle)
        
        let textView = IQTextView()
        textView.placeholder = "Describe your problem..."
        textView.placeholderTextColor = UIColor(hex: 0x999999)
        textView.layer.cornerRadius = 5
        textView.clipsToBounds = true
        textView.font = .systemFont(ofSize: 16)
        tvContent = textView
        scrollView.addSubview(textView)
        
        let imageTitle = UILabel()
        imageTitle.applyStyle.text("Screenshots").font(UIFont(name: "ArialMT", size: 16)!)
        scrollView.addSubview(imageTitle)
        
        let imagesContainer = UIView()
        imagesContainer.layer.cornerRadius = 5
        imagesContainer.clipsToBounds = true
        imagesContainer.backgroundColor = .white
        scrollView.addSubview(imagesContainer);
        
        let imageStack = UIStackView()
        imageStack.axis = .horizontal
        imageStack.distribution = .equalSpacing
        imagesContainer.addSubview(imageStack)
        
        imageStack.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 15, left: 11, bottom: 15, right: 11))
        }
        
        for i in 0...2 {
            let btn = UIButton(type: .custom)
            btn.applyStyle.backgroundColor(UIColor(hex: 0xFFAF6C)).image(addImage, for: .normal).addTarget(self, action: #selector(actionOnTakePhoto(sender:)), for: .touchUpInside)
            btn.layer.applyStyle.cornerRadius(15).masksToBounds(true)
            btn.addTarget(self, action: #selector(actionOnTakePhoto), for: .touchUpInside)
            imageStack.addArrangedSubview(btn)
            btn.tag = 100 + i
            btn.snp_makeConstraints { (make) in
                make.height.equalTo(100)
                make.width.equalTo(100)
            }
        }
        
        let btn = UIButton(type: .system)
        btn.applyStyle.title("Submit", for: .normal).clipsToBounds(true).titleColor(.white, for: .normal).frame(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-100, height: 50)).addTarget(self, action: #selector(actionOnSubmit(sender:)), for: .touchUpInside)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 25
        btn.setGradientBackground(colorOne: UIColor(red: 1, green: 0.41, blue: 0.42, alpha: 1), colorTwo: UIColor(red: 1, green: 0.69, blue: 0.42, alpha: 1), startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
        scrollView.addSubview(btn)
        
        btn.snp_makeConstraints { (make) in
            make.bottom.equalTo(49)
            make.height.equalTo(50)
            make.width.equalTo(UIScreen.main.bounds.size.width-100)
            make.leading.equalTo(50)
            make.trailing.equalTo(-50)
            make.top.equalTo(imagesContainer.snp_bottom).offset(55)
        }
        
        imagesContainer.snp_makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(130)
            make.top.equalTo(imageTitle.snp_bottom).offset(22)
        }
        
        imageTitle.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(textView.snp_bottom).offset(25)
        }
        
        textView.snp_makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(200)
            make.top.equalTo(labelTitle.snp_bottom).offset(21)
        }
        
        labelTitle.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(22)
        }
    }
}
