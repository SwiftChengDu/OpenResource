//
//  NetworkTool.swift
//  Connection
//
//  Created by 杨涵 on 16/4/8.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class NetworkTool: NSObject {
    /**
     * 请求json
     *
     * @param method        HTTP 请求方法
     * @param URLString     URL字符串
     * @param parameters    参数字典
     * @param completion    完成回调，返回networkresponse
    */
    class func requestJSON(method: Alamofire.Method, URLString: String, parameters: [String: AnyObject]? = nil, completion:(response: NetworkResponse?) -> ()) {
        Alamofire.request(method, URLString, parameters: parameters, encoding: .URL, headers: nil).responseJSON { (JSON) in
            switch JSON.result {
            case .Success:
                if let value = JSON.result.value {
                    let nResponse = NetworkResponse(dict: value as! [String:AnyObject])
                    completion(response: nResponse)
                }
            case .Failure(let error):
                debugPrint(error)
            }
        }
    }
}
