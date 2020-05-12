//
//  MRPhotoBrowserLog.swift
//  MRPhotoBrowserLog
//
//  Created by biz on 2020/4/12.
//  Copyright © 2020 biz. All rights reserved.
//

import Foundation

public struct MRPhotoBrowserLog {
    
    /// 日志重要程度等级
    public enum Level: Int {
        case low = 0
        case middle
        case high
        case forbidden
    }
    
    /// 允许输出日志的最低等级。`forbidden`为禁止所有日志
    public static var printLevel: Level = .forbidden
    
    public static func low(_ item: @autoclosure () -> Any) {
        if printLevel.rawValue <= Level.low.rawValue {
            print("[JXPhotoBrowser] [low]", item())
        }
    }
    
    public static func middle(_ item: @autoclosure () -> Any) {
        if printLevel.rawValue <= Level.middle.rawValue {
            print("[JXPhotoBrowser] [middle]", item())
        }
    }
    
    public static func high(_ item: @autoclosure () -> Any) {
        if printLevel.rawValue <= Level.high.rawValue {
            print("[JXPhotoBrowser] [high]", item())
        }
    }
}
