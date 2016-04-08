//
//  IBInspectableView.swift
//  Connection
//
//  Created by 杨涵 on 16/4/8.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

//@IBDesignable 可以实时渲染
@IBDesignable class IBInspectableView: UIView {
    @IBInspectable var kCornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = kCornerRadius
            layer.masksToBounds = true
        }
    }
}

@IBDesignable class IBInspectableImageView: UIImageView {
    @IBInspectable var kCornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = kCornerRadius
            layer.masksToBounds = true
        }
    }
}

@IBDesignable class IBInspectableButton: UIButton {
    @IBInspectable var kCornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = kCornerRadius
            layer.masksToBounds = true
        }
    }
    @IBInspectable var kCanHighlight: Bool = true
    
    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            super.highlighted = kCanHighlight
        }
    }
}