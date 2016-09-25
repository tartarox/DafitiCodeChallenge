//
//  ImageScrollView.swift
//  ZoomScrollTest
//
//  Created by Fabio Yudi Takahara on 23/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit

class ImageScrollView: UIScrollView, UIScrollViewDelegate {
    
    var imageView = UIImageView.init()
    
    init(frame: CGRect, imageUrl:String) {
        super.init(frame: frame)
        
        self.imageView = UIImageView.init(frame: CGRectMake(0, 0, frame.width, frame.height))
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.imageView.hnk_setImageFromURL(NSURL.init(string: imageUrl)!, placeholder: UIImage.init(named: "Image_Background"), format: nil, failure: nil) { (loadedImage) in
            
            self.imageView.image = loadedImage
        }

        self.addSubview(self.imageView)
        
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 6.0;
        self.delegate = self
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
