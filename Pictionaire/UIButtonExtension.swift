//
//  UIButtonExtension.swift
//  Pictionaire
//
//  Created by Abhi Singh on 12/5/17.
//  Copyright © 2017 Abhi Singh. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func loadPulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.90
        pulse.toValue = 1.50
        pulse.autoreverses = true
        pulse.repeatCount = 1.5
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    
    func quickPulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.90
        pulse.toValue = 1.1
        pulse.autoreverses = true
        pulse.repeatCount = 1.5
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    
    /*
    func continuousPulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 100
        pulse.fromValue = 0.75
        pulse.toValue = 0.85
        pulse.autoreverses = true
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 0.7
        
        layer.add(pulse, forKey: nil)
    }
    */
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.3
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1

        layer.add(flash, forKey: nil)
    }
    
    func rotation() {
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = 0.0
        rotate.toValue = CGFloat(Double.pi * 1.5)
        rotate.duration = 0.6
        
        layer.add(rotate, forKey: nil)
    }
    
}

