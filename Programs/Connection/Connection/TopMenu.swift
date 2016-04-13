//
//  TopMenu.swift
//  Connection
//
//  Created by 杨涵 on 16/4/11.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

protocol TopMenuDelegate: NSObjectProtocol {
    /**
     点击某个按钮
     -parameter topMenu: topMenu
     -parameter index:按钮index
    */
    func topMenu(topMenu: TopMenu, didClickButton index:Int)
}
class TopMenu: UIView {

    @IBOutlet var buttons: [DHButton]!
    @IBOutlet private weak var indicatorLabel: UILabel!
    weak var delegate: TopMenuDelegate?
    
    var showText: (String, String)? {
        didSet {
            buttons[0].setTitle("\(showText!.0)", forState: .Normal)
            buttons[1].setTitle("\(showText!.1)", forState: .Normal)
        }
    }
    
    var toIndex: Int = 0 {
        didSet {
            guard toIndex <= buttons.count && toIndex >= -1 else {
                return
            }
            var center = indicatorLabel.center
            center.x = buttons[toIndex].center.x
            UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5.0, options: [], animations: { 
                self.indicatorLabel.center = center
                }, completion: nil)
        }
    }
    
    @IBAction func buttonClick(sender: DHButton) {
        let index = sender.tag
        guard index != toIndex else {
            return
        }
        toIndex = index
        delegate?.topMenu(self, didClickButton: index)
    }
    
    class func loadFromNib() -> TopMenu {
        return NSBundle.mainBundle().loadNibNamed("TopMenu", owner: self, options: nil).last as! TopMenu
    }
}
