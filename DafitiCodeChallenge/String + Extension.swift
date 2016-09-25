//
//  String + Extension.swift
//  DafitiCodeChallenge
//
//  Created by Fabio Yudi Takahara on 22/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit

extension String {

    func formatDateString() -> String {
        
        let stringArray = self.componentsSeparatedByString("-")
        return String(format: "%@ / %@ / %@", stringArray[2], stringArray[1], stringArray[0])
    }
}
