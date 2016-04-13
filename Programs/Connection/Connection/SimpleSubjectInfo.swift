//
//  SimpleSubjectInfo.swift
//  Connection
//
//  Created by 杨涵 on 16/4/12.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

class SimpleSubjectInfo: NSObject {
    
    var subjectID: String?
    var title: String?
    var isOfficial: String?
    
    init(dict: [String: AnyObject]?) {
        super.init()
        
        guard dict?.count > 0 else {
            return
        }
        
        setValuesForKeysWithDictionary(dict!)
    }
}
