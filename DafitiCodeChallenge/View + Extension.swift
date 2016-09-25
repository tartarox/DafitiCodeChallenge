//
//  View + Extension.swift
//  DafitiCodeChallenge
//
//  Created by Fabio Yudi Takahara on 23/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit

extension UIView {
    
    func popAnimation(){
        
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformMakeScale(1.2, 1.2)
        }) { (true) in
            UIView.animateWithDuration(0.3, animations: {
                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            })
        }
    }
}


