//
//  EditRecordViewController.swift
//  PocketBook
//
//  Created by 张嘉夫 on 2017/3/9.
//  Copyright © 2017年 张嘉夫. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class EditRecordViewController: FormViewController {

    var record: Record!
    let realm = try! Realm()
    var categorys : Results<Category>!
    var options = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit"
        
        categorys = realm.objects(Category.self)
        for category in categorys {
            options.append(category.content)
        }
        
        form +++ Section()
            <<< DecimalRow("numRow"){
                $0.title = "金额"
                $0.placeholder = "¥"
                $0.value = record.num
            }.onChange({ (row) in
                
                if let value = row.value {
                    try! self.realm.write {
                        self.record.num = value
                    }
                }
                
            })
            <<< TextRow("desRow"){
                $0.title = "描述"
                $0.value = record.des
                }.onChange({ (row) in
                    
                    if let value = row.value {
                        try! self.realm.write {
                            self.record.des = value
                        }
                    }
                    
                })
            <<< DateTimeRow("timeRow"){
                $0.title = "消费时间"
                $0.value = record.time
                }.onChange({ (row) in
                    
                    if let value = row.value {
                        try! self.realm.write {
                            self.record.time = value
                        }
                    }
                    
                })
            <<< PushRow<String>("categoryRow"){
                $0.title = "类别"
                $0.options = options
                $0.value = record.category?.content
                $0.selectorTitle = "Choose a category"
            }.onChange({ (row) in
                try! self.realm.write {
                    self.record.category = self.categorys[self.options.index(of: row.value!)!]
                    print("已将类别修改为：\(self.record.category?.content)")
                }
            })
        
        form +++ Section()
            <<< ButtonRow(){
                $0.title = "Done"
            }.onCellSelection({ (cell, row) in
                self.dismiss(animated: true, completion: nil)
            })
    }
    
}
