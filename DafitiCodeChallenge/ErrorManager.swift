//
//  ErrorManager.swift
//  DafitiCodeChallenge
//
//  Created by Fabio Yudi Takahara on 23/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit

class ErrorManager: NSObject {
    
    class func showConnectionError(viewController:UIViewController) {
        
        let alert = UIAlertController(title: "Oops!", message:"You request did failed, please check your connection and try again", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default) { _ in })
        viewController.presentViewController(alert, animated: true){}
    }

}
