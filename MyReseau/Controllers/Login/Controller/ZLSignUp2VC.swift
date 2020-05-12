//
//  ZLSignUp2VC.swift
//  MyReseau
//
//  Created by fan li on 2020/4/4.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import FirebaseStorage
import FirebaseAuth
@_exported import Photos
@_exported import TZImagePickerControllerSwift

class ZLSignUp2VC: ZLBaseVC,UITextFieldDelegate,TZImagePickerControllerDelegate{
    
    
    @IBOutlet weak var btnTakePhoto: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var viewAge: UIView!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var tfGender: UITextField!
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    
    var token : SignUpToken?
    
    private var imageToken:String?
    private var imageName:String?
    private var imageResult : [String:String]?
    private var gender : Int?
    private var age : Int?
    private var location : [OptionData] = []
    
    var email : String?
    var psw : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        btnDone.setGradientBackground(colorOne: UIColor(red: 1, green: 0.41, blue: 0.42, alpha: 1), colorTwo: UIColor(red: 1, green: 0.69, blue: 0.42, alpha: 1), startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
        viewGender.layer.cornerRadius = 10;
        viewGender.layer.borderColor = UIColor(hex: 0xFFAD6C).cgColor
        viewGender.layer.borderWidth = 0.5
        
        viewAge.layer.cornerRadius = 10;
        viewAge.layer.borderColor = UIColor(hex: 0xFFAD6C).cgColor
        viewAge.layer.borderWidth = 0.5
        
        viewLocation.layer.cornerRadius = 10;
        viewLocation.layer.borderColor = UIColor(hex: 0xFFAD6C).cgColor
        viewLocation.layer.borderWidth = 0.5
        btnTakePhoto.imageView?.contentMode = .scaleAspectFill
        
        view.backgroundColor = UIColor.hex(hexString: "F3F3F3")
    }

    @IBAction func actionOnRegist(_ sender: Any) {
        if tfGender.text?.count == 0 {
            HUD.flash(.label("Gender is required."),delay: 1);return
        } else if tfAge.text?.count == 0 {
            HUD.flash(.label("Age  is required."),delay: 1);return
        } else if tfLocation.text?.count == 0 {
            HUD.flash(.label("Location is required."),delay: 1);return
        } else if imageName == nil {
            HUD.flash(.label("Photo is required."),delay: 1);return
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
        
        HUD.flash(.progress,delay: 60)
        Auth.auth().signIn(withEmail: self.email ?? "", password: self.psw ?? "") {(result, error) in
            guard let user = result?.user, error == nil else{
                HUD.hide()
                return
            }
            ReseauUser = user
            ResUser.user?.userInfo.firebaseUID = user.uid
            ResUser.user?.userInfo.imgUrl = user.photoURL?.absoluteString
            ResUser.user?.save()
            do {

                UserDefaults.standard.set(true, forKey: "login")
                
                let encoder = JSONEncoder()
                let data = try encoder.encode(ResUser.user?.userInfo)
                print("struct convert to data")

                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                ReseauDB.collection(fireCollectionUserKey).document(ReseauUser?.uid ?? "").setData(dict as! [String : Any]){ err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        HUD.hide()
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kLoginSuccessNotice), object: nil)
                        HUD.flash(.label("send success"))
                    }
                }
            } catch {
                print(error)
            }
            
            UserDefaults.standard.setValue(self.email, forKey: "psw")
            UserDefaults.standard.setValue(self.psw, forKey: "email")
        }
        
    }
    
    @IBAction func actionOnTakePhoto(_ sender: UIButton) {
        let imgPicker = ImagePickerVC(delegate: self, maxImagesCount: 1, columnNumber: 4, pushPhotoPickerVc: false)
        imgPicker.allowTakePicture = false
        imgPicker.allowCrop = false
        imgPicker.allowPickingVideo = false
        imgPicker.modalPresentationStyle = .fullScreen
        present(imgPicker, animated: true, completion: nil)
    }
    
    //MARK: ImagePickerDelegate
    func imagePickerController(_ picker: TZImagePickerController, didFinishPicking photos: [UIImage], sourceAssets: [PHAsset], isSelectOriginalPhoto: Bool, infos: [Dictionary<String, Any>]?) {
        let img = photos.first!
        btnTakePhoto.setImage(img, for: .normal)
        picker.dismiss(animated: true, completion: {
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
                }
            }
        })
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
