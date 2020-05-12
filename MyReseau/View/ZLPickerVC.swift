//
//  ZLPickerVC.swift
//  MyReseau
//
//  Created by mac on 2020/4/7.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class ZLPickerVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    
    var options:[ZLOption]?
    var completeBlock:((ZLOption)->())?
    lazy var pickerView : UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width-200, width: UIScreen.main.bounds.width, height: 200))
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.backgroundColor = UIColor(hex: 0xf1f1f1)
        return pickerView
    }()
    
    init(options:[ZLOption],completeBlock:@escaping ((ZLOption)->())) {
        super.init(nibName: nil, bundle: nil)
        self.options = options
        self.completeBlock = completeBlock
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let g = UITapGestureRecognizer(target: self, action: #selector(actionOnCancel))
        view.superview?.addGestureRecognizer(g)
        configUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.superview?.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-240, width: UIScreen.main.bounds.width, height: 240)
    }
    
    private func configUI() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        toolBar.backgroundColor = UIColor.white
        toolBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionOnCancel))
        cancelItem.setTitleTextAttributes([.foregroundColor:UIColor.white,
                                           .font:UIFont.systemFont(ofSize: 15)
        ], for: .normal)
        let flexbleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionOnDone))
        doneItem.setTitleTextAttributes([.foregroundColor:UIColor.white,
                                           .font:UIFont.boldSystemFont(ofSize: 15)
        ], for: .normal)
        toolBar.setItems([cancelItem,flexbleItem,doneItem], animated: true)
        toolBar.backgroundColor = UIColor.hex(0xFF686B)
        view.addSubview(toolBar)
        toolBar.snp_makeConstraints { (make) in
            make.top.equalTo(self.view);
            make.leading.equalTo(self.view);
            make.trailing.equalTo(self.view);
            make.height.equalTo(40);
        }
        view.addSubview(pickerView)
        pickerView.snp_makeConstraints { (make) in
            make.leading.equalTo(self.view);
            make.trailing.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.height.equalTo(200);
            make.top.equalTo(toolBar.snp_bottom);
        }
    }
    
    @objc private func actionOnCancel() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func actionOnDone() {
        self.completeBlock?((options?[pickerView.selectedRow(inComponent: 0)])!)
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        options!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options![row].displayText
    }
}
