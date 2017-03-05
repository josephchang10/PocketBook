//
//  RecordCollectionViewLayout.swift
//  PocketBook
//
//  Created by 张嘉夫 on 2017/3/5.
//  Copyright © 2017年 张嘉夫. All rights reserved.
//

import UIKit

class RecordCollectionViewLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        minimumLineSpacing = 20
        minimumInteritemSpacing = 20
    }
    
}
