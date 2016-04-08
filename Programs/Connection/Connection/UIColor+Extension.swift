//
//  UIColor+Extension.swift
//  Connection
//
//  Created by 杨涵 on 16/4/8.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

extension UIColor {
    /**
    创建颜色
     
     - parameter R:红
     - parameter G:绿
     - parameter B:蓝
     - parameter A:透明度
    */
    class func colorWithRGBA(R: Float, G: Float, B: Float, A: Float = 1.0) -> UIColor {
        return UIColor(red: CGFloat(R/255.0), green: CGFloat(G/255.0), blue: CGFloat(B/255.0), alpha: CGFloat(A))
    }
}
