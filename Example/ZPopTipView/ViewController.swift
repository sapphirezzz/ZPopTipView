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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    @IBAction func clickButton(sender: UIButton) {
        sender.selected = !sender.selected

        if sender.selected {

            ZPopTipView.show("Hello World! Lalalalala!", onView: leftInsideView, inView: containerView, delegate: self, direction: .Any)

//            ZPopTipView.show("Hello World! Lalalalala!", onView: insideView, inView: containerView, delegate: self, direction: .Down)
            
//            ZPopTipView.show("Hello World!", onView: rightInsideView, inView: containerView, delegate: self, direction: .Up)
        }else {
            ZPopTipView.remove(view)
        }
    }
}

extension ViewController: ZPopTipViewDelegate {

    func zPopTipViewDismissAfterTap() {
        button.selected = !button.selected
    }
}
