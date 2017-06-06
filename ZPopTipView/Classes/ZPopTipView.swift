//
//  ZPopTipView.swift
//  test
//
//  Created by Zack･Zheng on 16/9/29.
//  Copyright © 2016年 Zack･Zheng. All rights reserved.
//

import UIKit

public protocol ZPopTipViewDelegate: class {
    func zPopTipViewDismissAfterTap()
}

public enum ZPopTipViewPointDirection {
    case Any
    case Up
    case Down
}

public class ZPopTipView: UIButton {
    
    static let padding: CGFloat = 10.0
    static let textInsets: UIEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
    static let pointHeight: CGFloat = 6
    static let viewTag: Int = 12321
    static let backgroundColor = UIColor(red: 0, green: 176.0 / 255, blue: 1.0, alpha: 1.0)
    static let font: UIFont = UIFont.systemFontOfSize(14.0)
    
    var point: CGPoint?
    var direction: ZPopTipViewPointDirection = .Up
    weak var delegate: ZPopTipViewDelegate?
    
    public class func remove(inView: UIView) {
        if let view = inView.viewWithTag(viewTag) as? ZPopTipView {
            view.removeFromSuperview()
        }
    }
    
    public class func show(text: String, onView: UIView, inView: UIView, delegate: ZPopTipViewDelegate?, direction: ZPopTipViewPointDirection?) {
        
        if let view = inView.viewWithTag(viewTag) as? ZPopTipView {
            view.removeFromSuperview()
        }
        
        let textMaxWidth = inView.bounds.width - 2 * padding - textInsets.left - textInsets.right
        let textMaxHeight = onView.bounds.height - textInsets.top - textInsets.bottom - pointHeight
        let textBounds = NSString(string: text).boundingRectWithSize(CGSize(width: textMaxWidth, height: textMaxHeight), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        let viewBounds = CGRect(x: 0, y: 0, width: textBounds.width, height: textBounds.height)
        let viewSize = CGSize(width: ceil(textBounds.size.width + textInsets.left + textInsets.right), height: ceil(textBounds.size.height + textInsets.top + textInsets.bottom + pointHeight))
        
        var pointDirection: ZPopTipViewPointDirection {
            if let direction = direction where direction != .Any {
                return direction
            }else {
                let pointY = onView.convertPoint(CGPoint(x: onView.bounds.size.width / 2, y: 0), toView: inView).y
                if pointY > viewSize.height + padding {
                    return .Up
                }else {
                    return .Down
                }
            }
        }
        
        var point: CGPoint {
            
            if .Up == pointDirection {
                return onView.convertPoint(CGPoint(x: onView.bounds.size.width / 2, y: 0), toView: inView)
            }else {
                return onView.convertPoint(CGPoint(x: onView.bounds.size.width / 2, y: onView.bounds.size.height), toView: inView)
            }
        }
        
        var viewFrame: CGRect {
            let halfInViewWidth = inView.bounds.width / 2
            
            var y: CGFloat {
                if .Up == pointDirection {
                    return point.y - viewSize.height
                }else {
                    return point.y
                }
            }
            
            if point.x == halfInViewWidth {
                let x = halfInViewWidth - viewSize.width / 2
                return CGRect(origin: CGPoint(x: ceil(x), y: floor(y)), size: viewSize)
            }else if point.x < halfInViewWidth {
                if point.x > viewSize.width / 2 + padding {// 可与onView保持居中
                    let x = point.x - viewSize.width / 2
                    return CGRect(origin: CGPoint(x: x, y: y), size: viewSize)
                }else {
                    let x = padding
                    return CGRect(origin: CGPoint(x: x, y: y), size: viewSize)
                }
            }else {
                if inView.bounds.width - point.x > viewSize.width / 2 + padding {// 可与onView保持居中
                    let x = point.x - viewSize.width / 2
                    return CGRect(origin: CGPoint(x: x, y: y), size: viewSize)
                }else {
                    let x = inView.bounds.width - padding - viewSize.width
                    return CGRect(origin: CGPoint(x: x, y: y), size: viewSize)
                }
            }
        }
        let view = ZPopTipView(frame: viewFrame)
        view.tag = viewTag
        view.point = point
        view.delegate = delegate
        view.direction = pointDirection
        view.addTarget(view, action: #selector(ZPopTipView.tapSelf(_:)), forControlEvents: .TouchUpInside)
        
        var labelViewFrame: CGRect {
            if .Up == pointDirection {
                return CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height - pointHeight)
            }else {
                return CGRect(x: 0, y: pointHeight, width: viewSize.width, height: viewSize.height - pointHeight)
            }
        }
        
        let label = UILabel(frame: CGRect(origin: CGPoint(x: textInsets.left, y: textInsets.top), size: textBounds.size))
        label.font = font
        label.text = text
        label.numberOfLines = 0
        label.textColor = UIColor.whiteColor()
        
        var labelView = UIView(frame: labelViewFrame)
        labelView.userInteractionEnabled = false
        labelView.backgroundColor = backgroundColor
        labelView.layer.cornerRadius = 8
        labelView.addSubview(label)
        
        var imageView: UIImageView {
            let imageView = UIImageView(frame: CGRect.zero)
            let imageWidth: CGFloat = 12.0
            let imageSize = CGSize(width: imageWidth, height: pointHeight)
            
            if .Up == pointDirection {
                if let image = UIImage(named: "up_indicator", inBundle: NSBundle(forClass: ZPopTipView.self), compatibleWithTraitCollection: nil) {
                    imageView.image = image
                }
                imageView.frame = CGRect(origin: CGPoint(x: point.x - view.frame.origin.x - imageWidth / 2, y: labelViewFrame.height), size: imageSize)
            }else {
                if let image = UIImage(named: "down_indicator", inBundle: NSBundle(forClass: ZPopTipView.self), compatibleWithTraitCollection: nil) {
                    imageView.image = image
                }
                imageView.frame = CGRect(origin: CGPoint(x: point.x - view.frame.origin.x - imageWidth / 2, y: 0), size: imageSize)
            }
            return imageView
        }
        view.addSubview(imageView)
        
        view.addSubview(labelView)
        inView.addSubview(view)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.beginAnimation()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.beginAnimation()
    }
    
    private func beginAnimation() {
        self.alpha = 0
        UIView.animateWithDuration(0.45) {
            self.alpha = 1.0
        }
    }
    
    func tapSelf(sender: UIButton) {
        delegate?.zPopTipViewDismissAfterTap()
        removeFromSuperview()
    }
}
