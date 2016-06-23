//
//  LeftRefreshView.swift
//  Connection
//
//  Created by 杨涵 on 16/4/12.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

enum LeftRefreshViewState {
    case Default, Pulling, Refreshing
}

private let kLeftRefreshViewWidth: CGFloat = 65.0

class LeftRefreshView: UIControl {

    private var scrollView: UIScrollView?
    
    private var beforeState: LeftRefreshViewState = .Default
    private var refreshState: LeftRefreshViewState = .Default  {
        didSet {
            switch refreshState {
            case .Default:
                imageView.shouldAnimation = false
                if beforeState == .Refreshing {
                    UIView.animateWithDuration(0.2, animations: {
                        var contentInset = self.scrollView!.contentInset
                        contentInset.left -= kLeftRefreshViewWidth
                        self.scrollView?.contentInset = UIEdgeInsetsZero;
                        debugPrint("\(self.dynamicType) \(#function) \(#line)")
                    })
                }
            case .Pulling:
                imageView.shouldAnimation = true
                debugPrint("\(self.dynamicType) \(#function) \(#line)")
            case .Refreshing:
                UIView.animateWithDuration(0.2, animations: {
                    var contenInset = self.scrollView!.contentInset
                    contenInset.left += kLeftRefreshViewWidth
                    self.scrollView?.contentInset = contenInset
                    debugPrint("\(self.dynamicType) \(#function) \(#line)")
                })
                
                //开始刷新
                sendActionsForControlEvents(.ValueChanged)
            }
            beforeState = refreshState
        }
    }

    private lazy var imageView: LeftImageView = {
        let y = (CGRectGetHeight(self.bounds) - kLeftRefreshViewWidth) * 0.5 - self.scrollView!.contentInset.top - kTabBarHeight
        let i = LeftImageView(frame: CGRectMake(0, y, kLeftRefreshViewWidth, kLeftRefreshViewWidth))
        i.image = UIImage(named: "loading0")
        i.contentMode = .Center
        return i
    }()
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if let s = newSuperview where s.isKindOfClass(UIScrollView.self) {
            s.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
            scrollView = s as? UIScrollView
            frame = CGRectMake(-kLeftRefreshViewWidth, 0, kLeftRefreshViewWidth, CGRectGetHeight(s.bounds))
            addSubview(imageView)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let leftInset = scrollView!.contentInset.left
        let offsetX = scrollView!.contentOffset.x
        
        let criticalValue = -leftInset - CGRectGetWidth(bounds)
        guard offsetX < 0 else {
            return
        }
        //拖动
        if scrollView!.dragging {
            if  refreshState == .Default && offsetX >= criticalValue {
                //完全显示出来
                refreshState = .Pulling
            }else if refreshState == .Pulling && offsetX >= criticalValue {
                //没有完全显示出来 或者 没有显示出来
                refreshState = .Default
            }
        }else {
            //结束拖动
            if refreshState == .Pulling {
                refreshState = .Refreshing
            }
        }
    }
    
    func endRefresh() {
        refreshState = .Default
    }
    
    deinit {
        if let s = scrollView {
            s.removeObserver(self, forKeyPath: "contentOffset")
        }
    }
}

private class LeftImageView: UIImageView {
    var shouldAnimation: Bool = false {
        didSet {
            if shouldAnimation {
                if !isAnimating() {
                    var images = [UIImage]()
                    for i in 0..<3 {
                        images.append(UIImage(named: "loading\(i)")!)
                    }
                    self.animationImages = images
                    self.animationDuration = 1.0
                    startAnimating()
                }
            }else {
                stopAnimating()
            }
        }
    }
}
