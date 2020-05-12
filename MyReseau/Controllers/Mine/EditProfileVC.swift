//
//  EditProfileVC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/8.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
@_exported import Kingfisher
@_exported import PKHUD
@_exported import Alamofire
@_exported import SnapKit
import FirebaseAuth
import TZImagePickerControllerSwift

class EditProfileVC: ZLBaseVC,UITextFieldDelegate,TZImagePickerControllerDelegate {
        
    @IBOutlet weak var btnTakePhoto: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var viewAge: UIView!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var tfGender: UITextField!
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var lblName: UILabel!
    
    private var imageName:String?
//    private var imageResult : [String:String]?
    private var gender : Int?
    private var age : Int?
    private var location : [OptionData] = []
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ReseauString("Profile")
        btnDone.setGradientBackground(colorOne: UIColor(red: 1, green: 0.41, blue: 0.42, alpha: 1), colorTwo: UIColor(red: 1, green: 0.69, blue: 0.42, alpha: 1), startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))


        NotificationCenter.default.addObserver(self, selector: #selector(updateUserInfo), name: NSNotification.Name.init(rawValue: kLoginSuccessNotice), object: nil)
        
        updateUserInfo()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        let rightBtn = UIButton()
        rightBtn.setBackgroundImage(UIImage(named: "omegshezhi"), for: .normal)
        rightBtn.addTarget(self, action: #selector(actionOnBack), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
    }
    
    @objc private func updateUserInfo() {
        location.removeAll()
        
        let userInfo = ResUser.user?.userInfo
        gender = userInfo?.gender
        age = userInfo?.age
        lblName.text = userInfo?.nickName
        btnTakePhoto.imageView?.contentMode = .scaleAspectFill
        
        if userInfo?.country != nil {
            let l = Location(id: userInfo?.countryId, name: userInfo?.country, code: userInfo?.tempStr6th)
            location.append(l)
        }
        
        if userInfo?.province != nil {
            let l = Location(id: userInfo?.provinceId, name: userInfo?.province, code: userInfo?.tempStr5th)
            location.append(l)
        }
        
        if userInfo?.city != nil {
            let l = Location(id: userInfo?.cityId, name: userInfo?.city, code: nil)
            location.append(l)
        }
        
        var a:[String] = []
        for l in location {
            a.append(l.name!)
        }
        tfLocation.text = a.joined(separator: ", ")
        
        
        if userInfo?.imgUrl != nil {
            
            let imgURL = userInfo?.imgUrl ?? ""
            btnTakePhoto.kf.setImage(with: URL(string: imgURL), for: .normal, placeholder: UIImage(named: "default_head"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        tfGender.text = userInfo?.gender == 1 ? "Man" : "Woman"
        tfAge.text = "\(userInfo?.age ?? 18)"
    }
    
    @objc func actionOnBack() {
        navigationController?.pushViewController(SettingVC(), animated: true)

    }
    @IBAction func actionOnTakePhoto(_ sender: UIButton) {
        let imgPicker = ImagePickerVC(delegate: self, maxImagesCount: 1, columnNumber: 4, pushPhotoPickerVc: false)
        imgPicker.allowTakePicture = false
        imgPicker.allowCrop = false
        imgPicker.allowPickingVideo = false
        imgPicker.modalPresentationStyle = .fullScreen
        present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: TZImagePickerController, didFinishPicking photos: [UIImage], sourceAssets: [PHAsset], isSelectOriginalPhoto: Bool, infos: [Dictionary<String, Any>]?) {
        let img = photos.first!
        btnTakePhoto.setImage(img, for: .normal)
        HUD.flash(.progress,delay: 60)
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
                    return
                }
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = downloadURL
                changeRequest?.commitChanges(completion: nil)
                self.imageName = downloadURL.absoluteString
                let user = ResUser.user?.userInfo
                user?.tempStr7th = self.imageName
                user?.imgUrl = self.imageName
                ResUser.user?.save()
            }
        }
        
          picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func actionOnDone(_ sender: Any) {
        if tfGender.text?.count == 0 {
            HUD.flash(.label("Gender is required."),delay: 1);return
        } else if tfAge.text?.count == 0 {
            HUD.flash(.label("Age  is required."),delay: 1);return
        } else if tfLocation.text!.count == 0 {
            HUD.flash(.label("Location is required."),delay: 1);return
        }
        
        let user = ResUser.user?.userInfo
        user?.gender = gender
        user?.age = age
        
        let country = location.first as? Location
        user?.country = country?.name
        user?.countryId = country?.id
        user?.tempStr6th = country?.code
        if location.count > 1 {
            let province = location[1] as? Location
            user?.province = province?.name
            user?.provinceId = province?.id
            user?.tempStr5th = province?.code
        }
        if location.count > 2 {
            let province = location[2] as? Location
            user?.city = province?.name
            user?.cityId = province?.id
        }
        user?.imgStatus = 2
        user?.tempStr7th = imageName
        user?.firebaseUID = ReseauUser?.uid
        
        ResUser.user?.save()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(ResUser.user?.userInfo)
            print("struct convert to data")

            let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            let docID = ReseauUser?.uid ?? ""
            ReseauDB.collection(fireCollectionUserKey).document(docID).updateData(dict as! [String : Any]){ (error) in
                print(error?.localizedDescription ?? "");
                HUD.flash(.label("update success"),delay: 1)
            }
        } catch {
            print(error)
        }
        
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if textField.superview==viewLocation {
            let locationDetailVC = ZLLocationSelectVC(datas: nil, type: 1);
            locationDetailVC.complete = { location in
                self.location = location
                var a:[String] = []
                for l in location {
                    a.append(l.name!)
                }
                textField.text = a.joined(separator: ", ")
            }
            navigationController?.pushViewController(locationDetailVC, animated: true)
        } else if textField.superview==viewGender {
            let options = [ZLOption(displayText: "Man", value: 1),
            ZLOption(displayText: "Woman", value: 2)
            ]
            let vc = ZLPickerVC(options: options,completeBlock: {option in
                textField.text = option.displayText
                self.gender = option.value as? Int
            })
            present(vc, animated: true, completion: nil)
        } else if textField.superview==viewAge {
            var a:[ZLOption] = []
            for i in 18...100 {
                a.append(ZLOption(displayText: String(i), value: i))
            }
            let vc = ZLPickerVC(options: a,completeBlock: {option in
                textField.text = option.displayText
                self.age = option.value as? Int
            })
            present(vc, animated: true, completion: nil)
        }
        return false
    }
    

}

