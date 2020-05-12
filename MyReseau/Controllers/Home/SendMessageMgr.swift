//
//  SendMessageMgr.swift
//  MyReseau
//
//  Created by fan li on 2020/4/10.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

let sendMaxTimes: Int = 10
let pickMaxTimes: Int = 10
let kCooldownTime: TimeInterval = 86400

let sendMessageKey = "sendMessageKey"
let pickMessageKey = "pickMessageKey"

let sendMessageForbiddenKey = "sendMessageForbiddenKey"
let pickMessageForbiddenKey = "pickMessageForbiddenKey"

class SendMessageMgr {
    static let instance: SendMessageMgr = SendMessageMgr()
    class func share() -> SendMessageMgr {
        return instance
    }
    lazy var sendArray:Array<TimeInterval> = {
        guard let arr = UserDefaults.standard.object(forKey: sendMessageKey) else{
            return Array<TimeInterval>()
        }
        return arr as! Array<TimeInterval>
    }()
    
    lazy var pickArray:Array<TimeInterval> = {
        guard let arr = UserDefaults.standard.object(forKey: pickMessageKey) else{
            return Array<TimeInterval>()
        }
        return arr as! Array<TimeInterval>
    }()
    
    func sendMessageState() -> Bool{
        if checkSendCoolTime() > 0 {
            return false
        }
        
        let timeInterval = Date().timeIntervalSince1970
        if sendArray.count < sendMaxTimes - 1 {
            sendArray.append(timeInterval)
        }else{
            let firstItem = sendArray[0]
            let distance = timeInterval - firstItem

            if distance < kCooldownTime {
                UserDefaults.standard.set(timeInterval, forKey: sendMessageForbiddenKey)
            }else{
                sendArray.removeFirst()
            }
            sendArray.append(timeInterval)
        }
        return true
    }
    
    func checkSendCoolTime() -> TimeInterval{
        guard let time = UserDefaults.standard.object(forKey: sendMessageForbiddenKey) else {
            return 0
        }
        let timeInterval = Date().timeIntervalSince1970 - (time as! TimeInterval)
        if (kCooldownTime - timeInterval) <= 0{
            UserDefaults.standard.removeObject(forKey: sendMessageForbiddenKey)
            sendArray.removeAll()
        }
        return kCooldownTime - timeInterval
    }
    func pickMessageState() -> Bool{
        if checkPickCoolTime() > 0 {
            return false
        }
        
        let timeInterval = Date().timeIntervalSince1970
        if pickArray.count < pickMaxTimes - 1 {
            pickArray.append(timeInterval)
        }else{
            let firstItem = pickArray[0]
            let distance = timeInterval - firstItem
            if distance < kCooldownTime {
                UserDefaults.standard.set(timeInterval, forKey: pickMessageForbiddenKey)
            }else{
                pickArray.removeFirst()
            }
            pickArray.append(timeInterval)
        }
        return true
    }
    
    func checkPickCoolTime() -> TimeInterval{
        guard let time = UserDefaults.standard.object(forKey: pickMessageForbiddenKey) else {
            return 0
        }
        let timeInterval = Date().timeIntervalSince1970 - (time as! TimeInterval)
        if (kCooldownTime - timeInterval) <= 0{
            UserDefaults.standard.removeObject(forKey: pickMessageForbiddenKey)
            pickArray.removeAll()
        }
        return kCooldownTime - timeInterval
    }
}
