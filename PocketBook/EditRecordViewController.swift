//
//  EditRecordViewController.swift
//  PocketBook
//
//  Created by 张嘉夫 on 2017/3/9.
//  Copyright © 2017年 张嘉夫. All rights reserved.
//

import UIKit
import Eureka

class EditRecordViewController: FormViewController {

    var record: Record!
    var didFinishEdit: ((_ num: Double, _ des: String, _ time: Date?)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EditRecordViewController.cancel))
        
        form +++ Section()
            <<< DecimalRow("numRow"){
                $0.title = "金额"
                $0.placeholder = "¥"
                $0.value = record.num
            }
            <<< TextRow("desRow"){
                $0.title = "描述"
                $0.value = record.des
            }
            <<< DateTimeRow("timeRow"){
                $0.title = "消费时间"
                $0.value = record.time
            }
        
        form +++ Section()
            <<< ButtonRow(){
                $0.title = "Done"
            }.onCellSelection({ (cell, row) in
                var num = self.record.num
                var des = self.record.des
                var time = self.record.time
                if let row = self.form.rowBy(tag: "numRow") as? DecimalRow {
                    if let value = row.value {
                        num = value
                    }
                }
                if let row = self.form.rowBy(tag: "desRow") as? TextRow {
                    if let value = row.value {
                        des = value
                    }
                }
                time = (self.form.rowBy(tag: "timeRow") as? DateTimeRow)?.value
                self.didFinishEdit?(num, des, time)
                self.dismiss(animated: true, completion: nil)
            })
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
