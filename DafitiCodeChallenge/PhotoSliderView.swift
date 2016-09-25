//
//  PhotoSliderView.swift
//  ZoomScrollTest
//
//  Created by Fabio Yudi Takahara on 23/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit

class PhotoSliderView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(frame: CGRect, imageArray:NSArray, startIndex: Int) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0
        
        //Alpha Animation
        UIView.animateWithDuration(0.6) { 
            self.alpha = 1
        }
        
        //Create a Image Scroll
        self.contentSize = CGSizeMake(CGFloat(imageArray.count) * frame.width, 0)
        self.contentOffset = CGPointMake(frame.width * CGFloat(startIndex), 0)
        self.pagingEnabled = true
        
        for i in 0 ... imageArray.count - 1 {
            
            let imageScrollView = ImageScrollView.init(frame: CGRectMake(CGFloat(i) * frame.width, 0, frame.width, frame.height), imageUrl: imageArray[i] as! String)
            self.addSubview(imageScrollView)
        
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
