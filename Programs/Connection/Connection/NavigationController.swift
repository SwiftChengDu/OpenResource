//
//  NavigationController.swift
//  Connection
//
//  Created by 杨涵 on 16/4/11.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar.translucent = false
        interactivePopGestureRecognizer?.delegate = nil
    }

    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_red"), style: .Plain, target: self, action: #selector(NavigationController.backButtonClick))
        }
    }
    
    func backButtonClick() {
        popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
