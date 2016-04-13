//
//  UIStoryboard+Extension.swift
//  Connection
//
//  Created by 杨涵 on 16/4/11.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

extension UIStoryboard {
    /**
     根据storyboard名称返回初始控制器
     
     -parameter name:名称
     -returns:初始控制器
    */
    
    class func initialViewController(name: String) -> UIViewController {
        let sb = UIStoryboard(name: name, bundle: nil)
        return sb.instantiateInitialViewController()!
    }
    
    /**
     根据 storyboard名称和标识符返回对应的控制器
     
     -parameter name:名称
     -parameter identifier:标识符
     -returns:对应的控制器
     */
    class func initialViewController(name:String, identifier:String) -> UIViewController {
        let sb = UIStoryboard(name: name, bundle: nil);
        return sb.instantiateViewControllerWithIdentifier(identifier)
    }
}
