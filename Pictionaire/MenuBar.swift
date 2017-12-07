//
//  MenuBar.swift
//  Pictionaire
//
//  Created by Abhi Singh on 12/5/17.
//  Copyright © 2017 Abhi Singh. All rights reserved.
//

import UIKit


class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var menuBarCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // let cv = UICollectionView(frame: .init(x: 0, y: 0, width: 375, height: 122), collectionViewLayout: layout)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)

        let skyBlueColor = UIColor(red: 124.0/255.0, green: 200.0/255.0, blue: 239.0/255.0, alpha: 0.7)
        let blueColor = UIColor(red: 56.0/255.0, green: 145.0/255.0, blue: 233.0/255.0, alpha: 0.4)
        let blackColor = UIColor(red: 83.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 0.75)
        // let endingColorOFGradient = UIColor(red: 56.0/255.0, green: 145.0/255.0, blue: 233.0/255.0, alpha: 0.6).cgColor
        
        cv.backgroundColor = skyBlueColor
        cv.layer.cornerRadius = 6.5
        // cv.contentInset = UIEdgeInsetsMake(0, 0, 200, 0) - moves content up/down/left/right by pixels
        // not working b/c cv's frame: .zero (not initialized)
        cv.isScrollEnabled = false

        cv.layer.shadowColor = UIColor.black.cgColor
        cv.layer.shadowOffset = CGSize(width: 0, height: 10)
        cv.layer.shadowOpacity = 0.5
        cv.layer.shadowRadius = 5
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false
        
        cv.dataSource = self
        cv.delegate = self
        // Note: needed to make menuBarCV from let -> lazy var bc cannot access self before views are initialized. By making them lazy var, gets created when it gets accessed and after views are initialized. For let usage, everything should be initialized already.
        // Reference: http://mikebuss.com/2014/06/22/lazy-initialization-swift/﻿
        
        return cv
        
    } ()
    
    let cellId = "cellId"

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        menuBarCV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        

        addSubview(menuBarCV)
        
        // call constraint extension function
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuBarCV)
        addConstraintsWithFormat(format: "V:|[v0]|", views: menuBarCV)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = UIColor.blue
        cell.layer.cornerRadius = 6.5
        cell.layer.masksToBounds = true
       
        return cell
        
    }
  
    // size of each cell = 1/3(view frame's width); height: entire frame height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // print("========== this da frame height: \(frame.height)============")
        return CGSize(width: frame.width / 3, height: frame.height + 5.0)
        
        // !: spacing issues pushes last cell down
        // fix: minInteritemSpacing func below
    }
    
    
    // fixes spacing issue; no spacing between items (cells)sl
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}













/* https://stackoverflow.com/questions/38112977/background-color-of-view-gradient
 
 // Attempted code to work with gradients
 let startingColorOfGradient = UIColor(red: 83.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 0.4).cgColor
 
 let endingColorOFGradient = UIColor(red: 56.0/255.0, green: 145.0/255.0, blue: 233.0/255.0, alpha: 0.6).cgColor
 
 let gradientLayer: CAGradientLayer = CAGradientLayer()
 gradientLayer.frame = cv.bounds
 gradientLayer.startPoint = CGPoint(x: 0.5, y: 19.0)
 gradientLayer.endPoint = CGPoint(x: 0.5, y:60.0)
 gradientLayer.colors = [startingColorOfGradient, endingColorOFGradient]
 
 cv.layer.insertSublayer(gradientLayer, at: 0)
 
 */





/* https://stackoverflow.com/questions/45498070/programatically-adding-constraints-to-uiview
 
// Alternate extension for programmatic constraints
extension UIView {
    func pinSubview(_ subview:UIView, toEdge edge:NSLayoutAttribute, withConstant constant:Float) {
        self.pinSubviews(self, subview2: subview, toEdge: edge, withConstant: constant)
    }
 
    func pinSubviews(_ subview1:UIView, subview2:UIView, toEdge edge:NSLayoutAttribute, withConstant constant:Float) {
        pin(firstSubview: subview1, firstEdge: edge, secondSubview: subview2, secondEdge: edge, with: constant)
    }
 
    func pin(firstSubview subview1:UIView, firstEdge edge1:NSLayoutAttribute, secondSubview subview2:UIView, secondEdge edge2:NSLayoutAttribute, with constant:Float) {
        let constraint = NSLayoutConstraint(item: subview1, attribute: edge1, relatedBy: .equal, toItem: subview2, attribute: edge2, multiplier: 1, constant: CGFloat(constant))
        self.addConstraint(constraint)
    }
 
    func pinSubview(_ subview:UIView, withHeight height:CGFloat) {
        let height = NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        self.addConstraint(height)
    }
 
    func pinSubview(_ subview:UIView, withWidth width:CGFloat) {
        let width = NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        self.addConstraint(width)
    }
}
 
*/
