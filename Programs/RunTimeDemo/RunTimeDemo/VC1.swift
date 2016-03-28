//
//  VC1.swift
//  RunTimeDemo
//
//  Created by 杨涵 on 15/9/22.
//  Copyright © 2015年 yanghan. All rights reserved.
//

import UIKit

class VC1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orangeColor()
        // Do any additional setup after loading the view.
        
        let str = "http://imge0.bdstatic.com/img/image/26171547af11b48f5a89bc279d9548811426747517.jpg"
        let url = NSURL(string: str)
        let request = NSURLRequest(URL: url!)
        var response:NSURLResponse?
        
        
        let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        
        self.view.addSubview(imageView)
        
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            imageView.image = UIImage(data: data)
        } catch {
            print("catch the exception")
        }
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
