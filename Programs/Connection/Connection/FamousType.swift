//
//  FamousType.swift
//  Connection
//
//  Created by 杨涵 on 16/4/11.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

class FamousType: NSObject {
    var typeID = 0
    var typeName: String?
    var isPrimary = 0
    var isOfficial = 0
    
    init(dict: [String: AnyObject]?) {
        super.init()
        
        guard dict?.count > 0 else {
            return
        }
        
        for (key,value) in dict! {
            let keyName = key as String
            if keyName == "typeID" {
                if let t = value as? String {
                    setValue(Int(t), forKey: "typeID")
                }else if let t = value as? Int {
                    setValue(t, forKey: "typeID")
                }
                continue
            }
            self.setValue(value, forKey: keyName)
        }
    }
}
