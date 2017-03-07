//
//  RecordNumberButton.swift
//  PocketBook
//
//  Created by 张嘉夫 on 2017/3/4.
//  Copyright © 2017年 张嘉夫. All rights reserved.
//

import UIKit

@IBDesignable

class RecordNumberButton: RecordWhiteButton {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        titleLabel?.font = UIFont.systemFont(ofSize: 50, weight: UIFontWeightThin)
    }
    
}
