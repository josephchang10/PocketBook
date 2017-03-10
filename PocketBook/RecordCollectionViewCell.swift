//
//  RecordCollectionViewCell.swift
//  PocketBook
//
//  Created by 张嘉夫 on 2017/3/5.
//  Copyright © 2017年 张嘉夫. All rights reserved.
//

import UIKit

class RecordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // warning: performance problem
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
}
