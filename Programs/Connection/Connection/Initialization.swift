//
//  Initialization.swift
//  Connection
//
//  Created by 杨涵 on 16/4/11.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

class Initialization: NSObject {
    class func initializationApearance(window: UIWindow?) {
        window?.backgroundColor = UIColor.whiteColor()
        
        let navBar = UINavigationBar.appearance()
        let navBarSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 64)
        let navBarImage = UIImage.imageWithColor(kAppearanceColor, size: navBarSize)
        navBar.setBackgroundImage(navBarImage, forBarMetrics: .Default)
        navBar.shadowImage = UIImage()
        navBar.tintColor = UIColor.whiteColor()
        
        navBar.titleTextAttributes = [
            NSFontAttributeName: kNavigationBarFont,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        let tabBar = UITabBar.appearance()
        tabBar.translucent = false
    }
}
