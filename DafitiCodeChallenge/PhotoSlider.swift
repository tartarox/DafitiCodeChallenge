//
//  PhotoSlider.swift
//  DafitiCodeChallenge
//
//  Created by Fabio Yudi Takahara on 25/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit

class PhotoSlider: UIView {
    
    var photoSliderView = PhotoSliderView()
    
    init(frame: CGRect, imageArray:NSArray, startIndex: Int) {
        super.init(frame: frame)
        
        let photoSliderView = PhotoSliderView.init(frame: CGRectMake(0, 0, frame.width, frame.height), imageArray: imageArray, startIndex: startIndex)
        self.addSubview(photoSliderView)
        
        //Top Shadow View
        let shadowImageView = UIImageView.init(frame: CGRectMake(0, 0, frame.width, 200))
        shadowImageView.image = UIImage.init(named: "Shadow_Overlay_Down")
        self.addSubview(shadowImageView)
        
        let closeButton = UIButton.init(type: UIButtonType.Custom)
        closeButton.frame = CGRectMake(frame.width - 40, 22, 30, 30)
        closeButton.setImage(UIImage.init(named: "CloseButton"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: #selector(dismissView), forControlEvents: UIControlEvents.TouchDown)
        self.addSubview(closeButton)
        
    }
    
    func dismissView() {
        UIView.animateWithDuration(0.6, animations: {
            
            self.alpha = 0
            
            }) { (true) in
                
                self.removeFromSuperview()
                
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
