//
//  ViewControllerIPhone.swift
//  DafitiCodeChallenge
//
//  Created by Fabio Yudi Takahara on 24/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit

class ViewControllerIPhone: ViewController {
    
    //________________________________________
    //MARK: Interface
    
    @IBOutlet weak var navigationHeightConstraint: NSLayoutConstraint!
    
    var lastContentOffset: CGFloat = 0
    var isElementHidden = false
    
    //________________________________________
    //MARK: Class
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Render cells
        self.deviceDidRotate()
    }
    
    //Render cells when user rotate device
    override func deviceDidRotate() {
        
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            self.cellWidth = (UIScreen.mainScreen().bounds.size.width - 20) / 3
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            self.cellWidth = (UIScreen.mainScreen().bounds.size.width - 15) / 2
        }
        
        guard let flowLayout = self.mainCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.itemSize = CGSize(width: self.cellWidth, height: self.cellWidth)
        flowLayout.invalidateLayout()
        
    }
    
    func showAnimation() {
        
        if self.isElementHidden == false {
            return
        }
        
        self.navigationHeightConstraint.constant = 120
        UIView.animateWithDuration(0.6) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideAnimation() {
        
        if self.isElementHidden == true {
            return
        }
        
        self.navigationHeightConstraint.constant = 0
        UIView.animateWithDuration(0.6) { 
            self.view.layoutIfNeeded()
        }
        
    }
    
    //________________________________________
    //MARK: ScrollView Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y < 40) {
            return
        }
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height - 5)) {
            return
        }
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            
            self.showAnimation()
            self.isElementHidden = false
            
        } else if (self.lastContentOffset < scrollView.contentOffset.y) {
            
            self.hideAnimation()
            self.isElementHidden = true
    
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
        
    }

}
