//
//  RecordCollectionViewLayout.swift
//  PocketBook
//
//  Created by 张嘉夫 on 2017/3/5.
//  Copyright © 2017年 张嘉夫. All rights reserved.
//

import UIKit

class RecordCollectionViewLayout: UICollectionViewFlowLayout {

    private let minItemSpacing: CGFloat = 26 //26为4.7寸屏幕上一排3个最大距离
    private var itemWidth: CGFloat = 90 {
        didSet {
            itemHeight = itemWidth / 90 * 107
        }
    }
    private var itemHeight: CGFloat = 107
    
    override func prepare() {
        super.prepare()
        minimumLineSpacing = minItemSpacing
        
        if let containerWidth = collectionView?.bounds.width {
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                let numberOfItemOneLine: CGFloat = UIScreen.main.bounds.size.width == 320 ? 2 : 3 //4英寸设备上一排显示两个
                itemWidth = (containerWidth-2*minItemSpacing-(numberOfItemOneLine-1)*minItemSpacing)/numberOfItemOneLine
            }
            
            itemSize = CGSize(width: itemWidth, height: itemHeight)
            sectionInset = UIEdgeInsets(top: 20, left: minItemSpacing, bottom: 20, right: minItemSpacing)
        }
        
    }
    
}
