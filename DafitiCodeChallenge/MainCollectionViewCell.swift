//
//  MainCollectionViewCell.swift
//  DafitiCodeChallenge
//
//  Created by MacBook on 21/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        
        self.layer.borderColor = UIColor.init(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1).CGColor
        self.layer.borderWidth = 1
    }
}
