//
//  Array + Extension.swift
//  DafitiCodeChallenge
//
//  Created by Fabio Yudi Takahara on 22/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit

extension NSArray {
    
    func formatGenres() -> String {
        
        var returnString = ""
        for genreString in self {
            
            if returnString.characters.isEmpty {
                returnString = String(format: "Genres: %@", genreString as! String)
                continue
            }
            
            returnString = returnString + ", " + (genreString as! String)
        }
        return returnString
    }
    
}
