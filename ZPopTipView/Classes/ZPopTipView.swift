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
    case upon
    case below
}

open class ZPopTipView: UIButton {

    static private let padding: CGFloat = 10.0
    static private let pointIndicatorHeight: CGFloat = 6
    static private let pointIndicatorWidth: CGFloat = 12
    static private let viewTag: Int = 12321
    static private let backgroundColor = UIColor(red: 1.0, green: 86.0 / 255, blue: 119.0 / 255, alpha: 1.0)
    static private let font: UIFont = UIFont.systemFont(ofSize: 14.0)

    weak var delegate: ZPopTipViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.beginAnimation()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.beginAnimation()
    }

    fileprivate func beginAnimation() {
        self.alpha = 0
        UIView.animate(withDuration: 0.45, animations: {
            self.alpha = 1.0
        })
    }

    @objc private func tapSelf(_ sender: UIButton) {
        delegate?.zPopTipViewDismissAfterTap()
        removeFromSuperview()
    }
    
    private class func textViewSize(withText text: String, inView: UIView) -> CGSize {
        
        let textViewSize: CGSize = {
            let textMaxWidth = inView.bounds.width - 2 * padding
            let rect = NSString(string: text).boundingRect(with: CGSize(width: textMaxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            return CGSize(width: rect.size.width + 2 * padding,
                          height: rect.size.height + 2 * padding)
        }()
        return textViewSize
    }
    
    private class func showTips(_ text: String, direction: ZPopTipViewPointDirection, onPoint point: CGPoint, textViewSize: CGSize, inView: UIView, delegate: ZPopTipViewDelegate?) {
        
        if let view = inView.viewWithTag(viewTag) as? ZPopTipView {
            view.removeFromSuperview()
        }

        let tipsViewX: CGFloat = {
            let textHalfWidth = textViewSize.width / 2
            if textHalfWidth <= point.x && textHalfWidth <= inView.bounds.width - point.x {
                return point.x - textHalfWidth // 和indicator水平居中
            } else if point.x > textViewSize.width {
                return inView.bounds.width - textViewSize.width // 靠着inView的右边
            } else {
                return 0 // 靠着inView的左边
            }
        }()
        let tipsViewY: CGFloat = direction == .upon ? point.y - pointIndicatorHeight - textViewSize.height : point.y
        
        let tipsViewFrame = CGRect(x: tipsViewX, y: tipsViewY, width: textViewSize.width, height: textViewSize.height + pointIndicatorHeight)
        let labelViewFrame = CGRect(origin: CGPoint(x: 0, y: direction == .upon ? 0 : pointIndicatorHeight), size: textViewSize)
        let indicatorFrame = CGRect(x: point.x - pointIndicatorWidth / 2 - tipsViewX,
                                    y: direction == .upon ? textViewSize.height : 0,
                                    width: pointIndicatorWidth,
                                    height: pointIndicatorHeight)
        let labelFrame = CGRect(x: padding, y: padding, width: labelViewFrame.width - 2 * padding, height: labelViewFrame.height - 2 * padding)

        let view = ZPopTipView(frame: tipsViewFrame)
        view.tag = viewTag
        view.delegate = delegate
        view.addTarget(view, action: #selector(ZPopTipView.tapSelf(_:)), for: .touchUpInside)
        
        let label = UILabel(frame: labelFrame)
        label.font = font
        label.text = text
        label.numberOfLines = 0
        label.textColor = UIColor.white
        
        let labelView = UIView(frame: labelViewFrame)
        labelView.isUserInteractionEnabled = false
        labelView.backgroundColor = backgroundColor
        labelView.layer.cornerRadius = 8
        labelView.addSubview(label)
        
        let imageView = UIImageView(frame: indicatorFrame)
        if .upon == direction {
            if let image = UIImage(named: "up_indicator", in: Bundle(for: ZPopTipView.self), compatibleWith: nil) {
                imageView.image = image
            }
        } else if let image = UIImage(named: "down_indicator", in: Bundle(for: ZPopTipView.self), compatibleWith: nil) {
            imageView.image = image
        }
        
        view.addSubview(imageView)
        view.addSubview(labelView)
        inView.addSubview(view)
    }
}

public extension ZPopTipView {

    class func remove(_ inView: UIView) {
        if let view = inView.viewWithTag(viewTag) as? ZPopTipView {
            view.removeFromSuperview()
        }
    }
    
    class func showTips(_ text: String, onPoint point: CGPoint, inView: UIView, delegate: ZPopTipViewDelegate?, direction: ZPopTipViewPointDirection? = nil) {

        let textViewSize = ZPopTipView.textViewSize(withText: text, inView: inView)

        let finalDirection: ZPopTipViewPointDirection = {
            if let direction = direction {
                return direction
            } else {
                return point.y >= pointIndicatorHeight + textViewSize.height ? .upon : .below
            }
        }()
        
        ZPopTipView.showTips(text, direction: finalDirection, onPoint: point, textViewSize: textViewSize, inView: inView, delegate: delegate)
    }
    
    class func showTips(_ text: String, onView: UIView, inView: UIView, delegate: ZPopTipViewDelegate?, direction: ZPopTipViewPointDirection? = nil) {

        let textViewSize = ZPopTipView.textViewSize(withText: text, inView: inView)

        if let direction = direction {
            let point: CGPoint = onView.convert(CGPoint(x: onView.bounds.size.width / 2,
                                          y: .upon == direction ? 0 : onView.bounds.size.height),
                                  to: inView)
            ZPopTipView.showTips(text, direction: direction, onPoint: point, textViewSize: textViewSize, inView: inView, delegate: delegate)
        } else {
            let onViewMinYCenterXPointRelativeRect = onView.convert(CGPoint(x: onView.bounds.size.width / 2, y: 0), to: inView)
            let finalDirection: ZPopTipViewPointDirection = onViewMinYCenterXPointRelativeRect.y >= pointIndicatorHeight + textViewSize.height ? .upon : .below
            let point: CGPoint = finalDirection == .upon ? onViewMinYCenterXPointRelativeRect : onView.convert(CGPoint(x: onView.bounds.size.width / 2, y: onView.bounds.size.height), to: inView)
            ZPopTipView.showTips(text, direction: finalDirection, onPoint: point, textViewSize: textViewSize, inView: inView, delegate: delegate)
        }
    }
}
