//
//  NetworkResponse.swift
//  Connection
//
//  Created by 杨涵 on 16/4/8.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

class NetworkResponse: NSObject {
    var codeMsg: String?
    var msg: String?
    var rtn: String?
    var data: [String: AnyObject]?
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        codeMsg = dict["codeMsg"] as? String
        msg = dict["msg"] as? String
        
        if let r = dict["rtn"] as? String {
            rtn = r
        }else if let r = dict["rtn"] as? Int {
            rtn = "\(r)"
        }
        
        data = dict["data"] as? [String: AnyObject]
    }
}
