//
//  DetailImageCollectionCell.swift
//  DafitiCodeChallenge
//
//  Created by MacBook on 21/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit

class DetailImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    
    override func awakeFromNib() {
        
        self.layer.borderColor = UIColor.init(white: 0.5, alpha: 1).CGColor
        self.layer.borderWidth = 1
    }
}
