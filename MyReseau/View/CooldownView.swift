//
//  CooldownView.swift
//  MyReseau
//
//  Created by fan li on 2020/4/11.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class CooldownView: UIView {
    var timer: Timer?
    var timerCount: TimeInterval = 0
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func updateCountTime(_ count: TimeInterval){
        timerCount = count
        fetchTimeString()
    }
    
    private func setupUI(){
        Bundle.main.loadNibNamed("CooldownView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if #available(iOS 10.0, *) {
            timer = Timer.init(timeInterval: 1, repeats: true, block: { [weak self] _ in
                self?.fetchTimeString()
            })
            RunLoop.current.add(timer!, forMode: .default)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func fetchTimeString() {
        if timerCount <= 0 {
            dismissView()
            return
        }
        timerCount -= 1
        let hours = Int(timerCount/3600)
        let minute = Int(timerCount - Double(hours*3600))/60
        let second = Int(timerCount - Double(hours*3600) - Double(minute*60))
        countDownLabel.text = String(format: "%02d:%02d:%02d", hours, minute, second)
    }

    @IBAction func closeAction(_ sender: Any) {
        dismissView()
    }
    
    func dismissView() {
        self.removeFromSuperview()
        timer?.invalidate()
        timer = nil
    }
}
