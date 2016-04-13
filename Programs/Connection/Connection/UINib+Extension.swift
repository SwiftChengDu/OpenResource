//
//  UINib+Extension.swift
//  Connection
//
//  Created by 杨涵 on 16/4/11.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

extension UINib {
    class func nibWithName(name: String) -> UINib {
        return UINib(nibName: name, bundle: nil)
    }
}
