//
//  RecordWhiteButton.swift
//  PocketBook
//
//  Created by 张嘉夫 on 2017/3/7.
//  Copyright © 2017年 张嘉夫. All rights reserved.
//

import UIKit

class RecordWhiteButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            switch isHighlighted {
            case true:
                backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
            case false:
                backgroundColor = UIColor.clear
            }
        }
    }

}
