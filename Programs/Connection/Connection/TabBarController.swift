//
//  TabBarController.swift
//  Connection
//
//  Created by 杨涵 on 16/4/11.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    @IBOutlet private weak var aTabBar: TabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        aTabBar.aDelegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        removeSystemTabbarSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        removeSystemTabbarSubviews()
    }
    
    private func removeSystemTabbarSubviews() {
        for v in tabBar.subviews {
            if v.superclass == UIControl.self {
                v.removeFromSuperview()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TabBarController: TabBarDelegate {
    func tabBar(tabBar: TabBar, didClickButton index: Int) {
        var aIndex = index
        if aIndex == 2 {
            let showVC = UIStoryboard.initialViewController("Show")
            presentViewController(showVC, animated: true, completion: nil)
            return
        }else if aIndex >= 2 {
            aIndex -= 1
        }
        selectedIndex = aIndex
    }
}
