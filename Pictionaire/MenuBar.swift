//
//  MenuBar.swift
//  Pictionaire
//
//  Created by Abhi Singh on 12/5/17.
//  Copyright © 2017 Abhi Singh. All rights reserved.
//

import UIKit


class MenuBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blue
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}




// https://stackoverflow.com/questions/45498070/programatically-adding-constraints-to-uiview
//extension UIView {
//    func pinSubview(_ subview:UIView, toEdge edge:NSLayoutAttribute, withConstant constant:Float) {
//        self.pinSubviews(self, subview2: subview, toEdge: edge, withConstant: constant)
//    }
//    
//    func pinSubviews(_ subview1:UIView, subview2:UIView, toEdge edge:NSLayoutAttribute, withConstant constant:Float) {
//        pin(firstSubview: subview1, firstEdge: edge, secondSubview: subview2, secondEdge: edge, with: constant)
//    }
//    
//    func pin(firstSubview subview1:UIView, firstEdge edge1:NSLayoutAttribute, secondSubview subview2:UIView, secondEdge edge2:NSLayoutAttribute, with constant:Float) {
//        let constraint = NSLayoutConstraint(item: subview1, attribute: edge1, relatedBy: .equal, toItem: subview2, attribute: edge2, multiplier: 1, constant: CGFloat(constant))
//        self.addConstraint(constraint)
//    }
//    
//    func pinSubview(_ subview:UIView, withHeight height:CGFloat) {
//        let height = NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
//        self.addConstraint(height)
//    }
//    
//    func pinSubview(_ subview:UIView, withWidth width:CGFloat) {
//        let width = NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
//        self.addConstraint(width)
//    }
//}

