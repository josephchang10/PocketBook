//
//  RecordKeyboard.swift
//  PocketBook
//
//  Created by 张嘉夫 on 2017/3/4.
//  Copyright © 2017年 张嘉夫. All rights reserved.
//

import UIKit

protocol RecordKeyboardDelegate: class {
    func keyWasTapped(character: String)
    func deleteKeyWasTapped()
    func doneKeyWasTapped()
    func digitKeyWasTapped()
}

class RecordKeyboard: UIView {

    weak var delegate: RecordKeyboardDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "RecordKeyboard" // 不包括 xib 后缀名
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    // MARK:- .xib 文件里的按钮 action
    
    @IBAction func keyTapped(_ sender: UIButton) {
        delegate?.keyWasTapped(character: sender.titleLabel!.text!) // 也可以选择发送 tag 值
    }
    
    @IBAction func deleteKeyTapped(_ sender: Any) {
        delegate?.deleteKeyWasTapped()
    }
    
    @IBAction func doneKeyTapped(_ sender: Any) {
        delegate?.doneKeyWasTapped()
    }
    
    @IBAction func digitKeyTapped(_ sender: Any) {
        delegate?.digitKeyWasTapped()
    }
    

}
