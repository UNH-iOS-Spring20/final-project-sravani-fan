//
//  EditPhotoView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/25.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import TZImagePickerControllerSwift
import FirebaseAuth
class EditPhotoView: CompleteBaseView,TZImagePickerControllerDelegate {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var tipLabel: UILabel!
    
    private var imageName:String?
    private var imageResult : [String:String]?
    
    override func setupUI(){
        Bundle.main.loadNibNamed("EditPhotoView", owner: self, options: nil)
        addSubview(backgroundView)
        backgroundView.frame = self.bounds
        backgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.setGradientBackground(colorOne: UIColor.hex(hexString: "#FFDF7C"),
                                          colorTwo: UIColor.hex(hexString: "#FF8D00"),
                                          startPoint: CGPoint.init(x: 0.5, y: 0),
                                          endPoint: CGPoint.init(x: 0.5, y: 1))
        super.setupUI()
    }

    @IBAction func photoAction(_ sender: Any) {
        let imgPicker = ImagePickerVC(delegate: self, maxImagesCount: 1, columnNumber: 4, pushPhotoPickerVc: false)
        imgPicker.allowTakePicture = false
        imgPicker.allowCrop = false
        imgPicker.allowPickingVideo = false
        imgPicker.modalPresentationStyle = .fullScreen
        topVC?.present(imgPicker, animated: true, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        let img = photoButton.currentBackgroundImage!
        let fileName = "\(CLongLong(round(Date().timeIntervalSince1970 * 1000.0)))"
        
        let path = String("avatar/\(ReseauUser?.uid ?? fileName).jpg")
        let photoRiverRef = ReseauStorageRef.child(path)
        _ = photoRiverRef.putData(img.jpegData(compressionQuality: 0.3) ?? Data(), metadata: nil) { (metadata, error) in
            HUD.hide()
            guard metadata != nil else {
                HUD.flash(.label(error?.localizedDescription),delay: 1)
                return
            }
            photoRiverRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    HUD.flash(.label(error?.localizedDescription),delay: 1)
                    return
                }
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = downloadURL
                changeRequest?.commitChanges(completion: nil)
                self.imageName = downloadURL.absoluteString
                ResUser.user?.userInfo.imgUrl = self.imageName
                ResUser.user?.userInfo.tempStr7th = self.imageName
                
                self.updateUserInfo()
            }
        }
        

        self.dismiss()
        
        let userInfo = ResUser.user?.userInfo
        userInfo?.tempStr7th = "temp"
        userInfo?.imgStatus = 2
        userInfo?.imgUrl = "temp"
        ResUser.user?.save()
        ProfileManager.canOpenProfile()
    }
    
    func imagePickerController(_ picker: TZImagePickerController, didFinishPicking photos: [UIImage], sourceAssets: [PHAsset], isSelectOriginalPhoto: Bool, infos: [Dictionary<String, Any>]?) {
        let img = photos.first!
        photoButton.setBackgroundImage(img, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
}
