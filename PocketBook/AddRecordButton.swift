//
//  AddRecordButton.swift
//  PocketBook
//
//  Created by 张嘉夫 on 2017/3/5.
//  Copyright © 2017年 张嘉夫. All rights reserved.
//

import UIKit
@IBDesignable
class AddRecordButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
    }
    

}
