//
//  DetailViewControllerIPhone.swift
//  DafitiCodeChallenge
//
//  Created by Fabio Yudi Takahara on 24/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit

class DetailViewControllerIPhone: DetailViewController {
    
    //____________________________________________________________________
    //MARK: Interface
    
    @IBOutlet weak var overiewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var overiewHeight:CGFloat = 0
    
    //____________________________________________________________________
    //MARK: Class
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.overiewHeight = getTextViewHeight()
        self.ajustScrollView()
        
    }
    
    override func renderMainImage() {
        
        self.mainImageView.hnk_setImageFromURL(NSURL.init(string: self.movieObject.fanart)!)
    }
    
    override func deviceDidRotate() {
        
        //remove photo Gallery
        if (self.view.viewWithTag(1) != nil) {
            let photoSlider = self.view.viewWithTag(1)! as! PhotoSlider
            photoSlider.dismissView()
        }
        
        self.ajustScrollView()
    }
    
    func ajustScrollView() {
        
        self.mainScrollView.contentSize = CGSizeMake(0, self.overiewHeightConstraint.constant + 528)
    }
    
    func getTextViewHeight() -> CGFloat {
        
        let fakeTextView = UITextView.init(frame: CGRectMake(8, 0, self.view.frame.width - 16, 0))
        fakeTextView.text = self.movieObject.overview
        let fixedWidth = fakeTextView.frame.size.width
        fakeTextView.sizeThatFits(CGSize(width: fakeTextView.frame.size.width, height: CGFloat.max))
        let newSize = fakeTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = fakeTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        return newFrame.height + 50
    }
    
    //____________________________________________________________________
    //MARK: Actions

    @IBAction func showOveriew(sender: UIButton) {
        
        sender.selected = !sender.selected
        
        if sender.selected {
            
            self.overiewHeightConstraint.constant = self.overiewHeight
            
            UIView.animateWithDuration(0.6) {
                
                self.overviewTextView.alpha = 1
                self.view.layoutIfNeeded()
            }
            
        } else {
            
            self.overiewHeightConstraint.constant = 0
            
            UIView.animateWithDuration(0.6) {
                
                self.overviewTextView.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
        
        self.ajustScrollView()
    }
    
    //____________________________________________________________________
    //MARK: UICollectionView Methods
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //Instance Photo Gallery and display
        let photoSliderView = PhotoSlider.init(frame: self.view.frame, imageArray: self.movieImages, startIndex: indexPath.row)
        photoSliderView.tag = 1 //For dismiss control
        self.view.addSubview(photoSliderView)
    }
    
}
