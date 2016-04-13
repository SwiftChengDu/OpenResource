//
//  ShowController.swift
//  Connection
//
//  Created by 杨涵 on 16/4/11.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

class ShowController: UIViewController {

    @IBOutlet private weak var videoPreveiwView:UIView!
    private var sound: SystemSoundID = kSystemSoundID_Vibrate
    
    private var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    private lazy var captureManager: AVCamCaptureManager = {
        let manager = AVCamCaptureManager()
        manager.delegate = self
        return manager
    }()
    
    override func viewDidLoad() {
    
        // Do any additional setup after loading the view.
        guard captureManager.setupSession() else {
            return
        }
        
        let newCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureManager.session)
        let view = videoPreveiwView
        let viewLayer = view.layer
        viewLayer.masksToBounds = true
        
        let bounds = view.bounds
        newCaptureVideoPreviewLayer.frame = bounds
        newCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        viewLayer.insertSublayer(newCaptureVideoPreviewLayer, atIndex: 0)
        self.captureVideoPreviewLayer = newCaptureVideoPreviewLayer
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            self.captureManager.session.startRunning()
        }
        super.viewDidLoad()
    }

    @IBAction private func closeButtonClick(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func takePhotoAction(sender: UIButton) {
        photoSound()
        captureManager.captureStillImage()
        
        let flashView = UIView(frame: self.videoPreveiwView.frame)
        flashView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(flashView)
        
        UIView.animateWithDuration(0.4, animations: {
            flashView.alpha = 0.0
            }) { (finished) in
                flashView .removeFromSuperview()
        }
    }
    
    @IBAction private func toggleCamera(sender: UIBarButtonItem) {
        captureManager.toggleCamera()
        
        captureManager.continuousFocusAtPoint(CGPointMake(0.5, 0.5))
    }
    
    private func photoSound() {
        let path = "/System/Library/Audio/UISounds/photoShutter.caf"
        AudioServicesCreateSystemSoundID(NSURL(string: path)!, &sound)
        AudioServicesPlaySystemSound(sound)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ShowController: AVCamCaptureManagerDelegate {
    func captureManagerStillImageCaptured(captureManager: AVCamCaptureManager!) {
        
    }
    
    func captureManager(captureManager: AVCamCaptureManager!, didFailWithError error: NSError!) {
        
    }
    
    func captureManagerDeviceConfigurationChanged(captureManager: AVCamCaptureManager!) {
        
    }
}
