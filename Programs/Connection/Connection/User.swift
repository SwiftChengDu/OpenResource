//
//  User.swift
//  Connection
//
//  Created by 杨涵 on 16/4/11.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

class User: NSObject {
    var userID: String?
    var nicname: String?
    var headUrl: String?
    var sex = 0
    var heat = 0
    var praiseCnt = 0
    var birthday: String?
    
    var age:Int {
        return (birthday?.age(withStyle: .Style1))!
    }
    
    var constellation: String? {
        return (birthday?.constellation(withStyle: .Style1))!
    }
    
    var signature: String?
    var isFamous = 0
    var onlineTime: String?
    var level = 0
    var isOfficial = 0
    var famousTypeInfo: FamousType?
    
    init(dict: [String: AnyObject]?) {
        super.init()
        
        guard dict?.count > 0 else {
            return
        }
        
        for (key, value) in dict! {
            let keyName = key as String
            if keyName == "famousTypeInfo" {
                famousTypeInfo = FamousType(dict: value as? [String:AnyObject])
                continue
            }
            self.setValue(value, forKey: keyName)
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
