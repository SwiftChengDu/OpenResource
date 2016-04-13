//
//  TabBar.swift
//  Connection
//
//  Created by 杨涵 on 16/4/11.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

protocol TabBarDelegate: NSObjectProtocol {
    /**
     点击某个按钮
     -parameter tabBar:tabBar
     -parameter index:按钮index
    */
    func tabBar(tabBar: TabBar, didClickButton index: Int)
}

class TabBar: UITabBar {
    weak var aDelegate: TabBarDelegate?
    
    private var selButton: DHButton?
    
    private lazy var btnImages: [String] = {
        return ["tabbar_home", "tabbar_discover", "tabbar_show", "tabbar_message", "tabbar_profile"]
    }()
    
    private lazy var buttons: [UIButton] = {
        return [UIButton]()
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for i in 0..<btnImages.count {
            let imageName = btnImages[i]
            let b = buttonWithImageName(imageName)
            b.tag = i
            if i == 0 {
                buttonClick(b)
            }
            addSubview(b)
            buttons.append(b)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = buttons.count
        let w = CGRectGetWidth(bounds) / CGFloat(count)
        let h = CGRectGetHeight(bounds)
        
        let frame = CGRectMake(0, 0, w, h)
        for b in buttons {
            b.frame = CGRectOffset(frame, CGFloat(b.tag)*w, 0)
        }
    }
    
    private func buttonWithImageName(imageName: String) -> DHButton {
        let b = DHButton(type: .Custom)
        let sImageName = imageName + "_sel"
        b.setImage(UIImage(named: imageName), forState: .Normal)
        b.setImage(UIImage(named: sImageName), forState: .Selected)
        b.addTarget(self, action: #selector(TabBar.buttonClick(_:)), forControlEvents: .TouchDown)
        return b
    }
    
    func buttonClick(button: DHButton) {
        guard selButton != button else {
            return
        }
        
        if button.tag != 2 {
            selButton?.selected = false
            button.selected = true
            selButton = button
        }
        
        aDelegate?.tabBar(self, didClickButton: button.tag)
    }
}
