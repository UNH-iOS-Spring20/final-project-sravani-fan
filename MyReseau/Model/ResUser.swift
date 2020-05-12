//
//  User.swift
//  MyReseau
//
//  Created by fan li on 2020/3/16.
//  Copyright © 2020 biz. All rights reserved.
//

import Foundation
import KakaJSON
class ResUser :  Codable, Convertible{
    required init() {
        account = Account()
        appClient = AppClient()
        photos = [Photo]()
        userInfo = UserInfo()
    }
    
    var account: Account?
    var appClient: AppClient
    var photos: [Photo]?
    var tokenDto: LoginTokenDto?
    var userInfo: UserInfo = UserInfo()
    
    static var _user : ResUser?
    static var imgToken = ""
    
    func save() {

        do {
            let data = try JSONEncoder().encode(self)
            ResUser._user = self
            UserDefaults.standard.set(data,forKey: "user")
            UserDefaults.standard.synchronize()
        } catch {
            
        }
    }
    
    
    static var user : ResUser? {
        if _user != nil {
            return _user
        }
        guard let data = UserDefaults.standard.data(forKey: "user") else {
            _user = ResUser()
            return _user
        }
        guard let us = try? JSONDecoder().decode(self, from: data) else {
            _user = ResUser()
            return _user
        }
        _user = us
        return _user
    }
}

// MARK: - Photo
class Photo: Codable, Convertible {
    required init() {}
    var reviewStatus, imgCode, gmID, id: Int?
    var imgURL: String?
    var userID: Int?

    enum CodingKeys: String, CodingKey {
        case gmID = "gmId"
        case id, imgCode
        case imgURL = "imgUrl"
        case reviewStatus
        case userID = "userId"
    }
}

// MARK: - Account
class Account: Codable, Convertible {
    required init() {}
    var userID: Int?
    var password: String?
    var createTime, restrictLogin, loginTime: Int?
    var gmFlag: Int?
    var socialNum, clientNum: String?
    var appType: Int?
    var email: String?
    var flshTime: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}

// MARK: - AppClient
class AppClient: Codable, Convertible {
    required init() {}
    var id: Int?
    var clientNum, appClientDescription: String?
    var auditingState, updateFlag: Int?
    var updateURL, updateDescription: String?
    var delFlag: Int?
    var spare1St, spare2Nd, spare3RD, spare4Th: String?
    var spare5Th, spare6Th, spare7Th, spare8Th: String?
    var spare9Th: String?
    var spare10Th, spare11Th, spare12Th: String?
    var spare13Th, spare14Th, spare15Th, spare16Th: String?
    var spare17Th: String?
    var spare18Th, spare19Th, spare20Th: String?
    var generalStatus: Int?
    var generalMaleMsg: String?
    var generalMaleSize: Int?
    var generalFemaleMsg: String?
    var generalFemaleSize, maleStatus: Int?
    var maleMsg: String?
    var maleSize, femaleStatus: Int?
    var femaleMsg: String?
    var femaleSize: Int?
    var stateSet: String?

    enum CodingKeys: String, CodingKey {
        case id, clientNum
        case appClientDescription = "description"
        case auditingState, updateFlag
        case updateURL = "updateUrl"
        case updateDescription, delFlag
        case spare1St = "spare1st"
        case spare2Nd = "spare2nd"
        case spare3RD = "spare3rd"
        case spare4Th = "spare4th"
        case spare5Th = "spare5th"
        case spare6Th = "spare6th"
        case spare7Th = "spare7th"
        case spare8Th = "spare8th"
        case spare9Th = "spare9th"
        case spare10Th = "spare10th"
        case spare11Th = "spare11th"
        case spare12Th = "spare12th"
        case spare13Th = "spare13th"
        case spare14Th = "spare14th"
        case spare15Th = "spare15th"
        case spare16Th = "spare16th"
        case spare17Th = "spare17th"
        case spare18Th = "spare18th"
        case spare19Th = "spare19th"
        case spare20Th = "spare20th"
        case generalStatus, generalMaleMsg, generalMaleSize, generalFemaleMsg, generalFemaleSize, maleStatus, maleMsg, maleSize, femaleStatus, femaleMsg, femaleSize, stateSet
    }

    init(id: Int?, clientNum: String?, appClientDescription: String?, auditingState: Int?, updateFlag: Int?, updateURL: String?, updateDescription: String?, delFlag: Int?, spare1St: String?, spare2Nd: String?, spare3RD: String?, spare4Th: String?, spare5Th: String?, spare6Th: String?, spare7Th: String?, spare8Th: String?, spare9Th: String?, spare10Th: String?, spare11Th: String?, spare12Th: String?, spare13Th: String?, spare14Th: String?, spare15Th: String?, spare16Th: String?, spare17Th: String?, spare18Th: String?, spare19Th: String?, spare20Th: String?, generalStatus: Int?, generalMaleMsg: String?, generalMaleSize: Int?, generalFemaleMsg: String?, generalFemaleSize: Int?, maleStatus: Int?, maleMsg: String?, maleSize: Int?, femaleStatus: Int?, femaleMsg: String?, femaleSize: Int?, stateSet: String?) {
        self.id = id
        self.clientNum = clientNum
        self.appClientDescription = appClientDescription
        self.auditingState = auditingState
        self.updateFlag = updateFlag
        self.updateURL = updateURL
        self.updateDescription = updateDescription
        self.delFlag = delFlag
        self.spare1St = spare1St
        self.spare2Nd = spare2Nd
        self.spare3RD = spare3RD
        self.spare4Th = spare4Th
        self.spare5Th = spare5Th
        self.spare6Th = spare6Th
        self.spare7Th = spare7Th
        self.spare8Th = spare8Th
        self.spare9Th = spare9Th
        self.spare10Th = spare10Th
        self.spare11Th = spare11Th
        self.spare12Th = spare12Th
        self.spare13Th = spare13Th
        self.spare14Th = spare14Th
        self.spare15Th = spare15Th
        self.spare16Th = spare16Th
        self.spare17Th = spare17Th
        self.spare18Th = spare18Th
        self.spare19Th = spare19Th
        self.spare20Th = spare20Th
        self.generalStatus = generalStatus
        self.generalMaleMsg = generalMaleMsg
        self.generalMaleSize = generalMaleSize
        self.generalFemaleMsg = generalFemaleMsg
        self.generalFemaleSize = generalFemaleSize
        self.maleStatus = maleStatus
        self.maleMsg = maleMsg
        self.maleSize = maleSize
        self.femaleStatus = femaleStatus
        self.femaleMsg = femaleMsg
        self.femaleSize = femaleSize
        self.stateSet = stateSet
    }
}

// MARK: - TokenDto
class LoginTokenDto: Codable, Convertible {
    required init() {}
    var token, refreshToken: String?
    var expiresIn: Int?

    init(token: String?, refreshToken: String?, expiresIn: Int?) {
        self.token = token
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
    }
}

// MARK: - UserInfo
class UserInfo: Codable, Convertible{
    required init() {}
    var firebaseUID: String?
    var userId: Int?
    var socialNum, nickName: String?
    var gender, age: Int?
    var imgUrl: String?
    var memberLevel: Int?
    var country, province, city: String?
    var maritalStaus: Int?
    var integral, countryId, provinceId, cityId: Int?
    var loginTime, imgStatus, appType: Int?
    var spareStr1st: String?
    var spareStr7th: String?
    var spareStr8th: String?
    var spareStr9th: String?
    var spareStr14th: String?
    var spareStr17th : String?
    var spareStr18th, spareStr19th: String?
    var spareNum1st, spareNum2nd, spareNum3rd, spareNum4th: Int?
    var spareNum5th, spareNum6th, spareNum7th, spareNum8th: Int?
    var spareNum9th, spareNum10th, isSugar: Int?
    var tempStr5th: String?
    var tempStr6th: String?
    var tempStr7th: String?
    var tempStr10th: String?
    var tempStr12th: String?
    var tempStr21th: String?
    var tempStr30th: String?
    var tempStr1st: String?
    var tempStr2nd: String?
    var isDel, isHidden, imImgStatus: Int?

}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
