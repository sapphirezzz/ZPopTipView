//
//  ViewController.swift
//  ZPopTipView
//
//  Created by sapphirezzz on 09/29/2016.
//  Copyright (c) 2016 sapphirezzz. All rights reserved.
//

import UIKit
import ZPopTipView

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var leftInsideView: UIView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var rightInsideView: UIView!
    
    private var count = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    @IBAction func clickButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {

            switch count % 10 {
            case 0:
                ZPopTipView.showTips("Hello World! Lalalalala!", onPoint: CGPoint(x: 100, y: 0), inView: containerView, delegate: self)
            case 1:
                ZPopTipView.showTips("Hel", onPoint: CGPoint(x: 100, y: 0), inView: containerView, delegate: self)
            case 2:
                ZPopTipView.showTips("Hello World! Lalalalala! HA HA H", onPoint: CGPoint(x: 100, y: 0), inView: containerView, delegate: self)
            case 3:
                ZPopTipView.showTips("Hello World! Lalalalala!", onPoint: CGPoint(x: 200, y: 0), inView: containerView, delegate: self)
            case 4:
                ZPopTipView.showTips("Hel", onPoint: CGPoint(x: 200, y: 0), inView: containerView, delegate: self)
            case 5:
                ZPopTipView.showTips("Hello World! Lalalalala! HA HA H", onPoint: CGPoint(x: 200, y: 0), inView: containerView, delegate: self)
            case 6:
                ZPopTipView.showTips("Hello World! Lalalalala!", onView: leftInsideView, inView: containerView, delegate: self)
            case 7:
                ZPopTipView.showTips("Hello", onView: leftInsideView, inView: containerView, delegate: self, direction: .upon)
            case 8:
                ZPopTipView.showTips("Hello World! Lalalalala! Hello World! Lalalalala! Hello World! Lalalalala!", onView: leftInsideView, inView: containerView, delegate: self)
            case 9:
                ZPopTipView.showTips("Hello World! Lalalalala!", onView: insideView, inView: containerView, delegate: self, direction: .below)
            default:
                break
            }
            count += 1
        }else {
            ZPopTipView.remove(view)
        }
    }
}

extension ViewController: ZPopTipViewDelegate {

    func zPopTipViewDismissAfterTap() {
        button.isSelected = !button.isSelected
    }
}
